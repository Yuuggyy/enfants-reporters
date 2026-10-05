# app/routers/ussd.py
from __future__ import annotations

import random
from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, Form, HTTPException, status
from fastapi.responses import PlainTextResponse
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.functions.ussdF import _clean, _con, _end, _get_session
from app.models.models import (
    Adolescent,
    AuditLog,
    CanalInscriptionEnum,
    Club,
    EncadreurNotification,
    StatutConsentementEnum,
    StatutInscriptionEnum,
)
from app.schemas.ussdschema import USSDRequest, USSDState

router = APIRouter(prefix="/ussd", tags=["USSD"])


# ---------------------------------------------------------------------------
# Logique d'enregistrement — identique à la route Web
# ---------------------------------------------------------------------------
async def _persist_adolescent(db: AsyncSession, data: dict) -> Adolescent:
    # 1. Vérification stricte de l'âge (12 - 17)
    if data["age"] < 12 or data["age"] > 17:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Le programme UNICEF s'adresse strictement aux adolescents âgés de 12 à 17 ans.",
        )

    # 2. ID unique non signifiant
    result1 = await db.execute(select(func.count()).select_from(Adolescent))
    next_id = (result1.scalar() or 0) + 1
    now = datetime.now()
    unique_id = f"ADO-{now.year}-{next_id:04d}"

    # 3. Club + encadreur de proximité (avec fallback province)
    stmt = (
        select(Club)
        .where(
            Club.province.ilike(f"%{data['province']}%"),
            Club.ville.ilike(f"%{data['ville']}%"),
        )
        .limit(1)
    )
    club = (await db.execute(stmt)).scalars().first()

    if not club:
        stmt = select(Club).where(Club.province.ilike(f"%{data['province']}%")).limit(1)
        club = (await db.execute(stmt)).scalars().first()

    club_id = club.id if club else None
    encadreur_id = club.encadreur_id if (club and club.encadreur_id) else "ENC-KIN-01"

    # 4. Dossier Adolescent (canal USSD → statut PENDING_ENCADREUR_VALIDATION)
    nouveau_statut = StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION

    ado = Adolescent(
        id=unique_id,
        prenom=data["prenom"].strip(),
        age=data["age"],
        sexe=data["sexe"].upper(),
        province=data["province"].strip(),
        ville=data["ville"].strip(),
        territoire=data.get("territoire") or None,
        milieu=data["milieu"],
        statut_scolaire=data["statut_scolaire"],
        handicap=data.get("handicap", False),
        description_handicap=data.get("description_handicap"),
        langue_preferee=data.get("langue_preferee", "FR"),
        telephone=data["telephone"].strip(),
        telephone_parent=data["telephone_parent"].strip(),
        club_id=club_id,
        canal_inscription=CanalInscriptionEnum.USSD,
        statut_inscription=nouveau_statut,
        statut_consentement=StatutConsentementEnum.EN_ATTENTE,
        mode_consentement="SMS / WhatsApp RapidPro",
        points_xp=50,
        certifie=False,
        date_inscription=datetime.now(),
    )
    db.add(ado)
    await db.flush()

    # 5. Notification encadreur
    canal_label = CanalInscriptionEnum.USSD.value
    handicap_info = (
        f" • Handicap: {ado.description_handicap}"
        if ado.handicap
        else "Pas d'handicap signalé"
    )
    notif = EncadreurNotification(
        id=f"NOTIF-{datetime.now().strftime('%Y%m%d%H%M%S')}-{random.randint(100, 999)}",
        encadreur_id=encadreur_id,
        adolescent_id=ado.id,
        type_notification="NOUVELLE_INSCRIPTION",
        titre=f"Nouvelle inscription {canal_label} : {ado.prenom} ({ado.age} ans, {ado.sexe})",
        message=(
            f"L'adolescent(e) {ado.prenom} ({ado.age} ans, sexe: {ado.sexe}, "
            f"{ado.ville}/{ado.province}, milieu: {ado.milieu}, statut: {ado.statut_scolaire}"
            f"{handicap_info}) souhaite rejoindre {club.nom if club else 'le réseau'}. "
            f"Canal d'origine : {canal_label}. "
            f"Contact Parent pour consentement : {ado.telephone_parent}."
        ),
        is_read=False,
        created_at=datetime.now(),
    )
    db.add(notif)

    # 6. Journal d'audit
    db.add(
        AuditLog(
            user_id=ado.id,
            user_role="ADOLESCENT",
            action="INSCRIPTION_CANAL",
            details=(
                f"Inscription de {ado.prenom} via canal {canal_label} "
                f"(Zone: {ado.province}/{ado.ville}, Sexe: {ado.sexe})"
            ),
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado


# ---------------------------------------------------------------------------
# Route principale USSD — un seul endpoint stateful
# ---------------------------------------------------------------------------
@router.post("", response_class=PlainTextResponse)
async def ussd_handler(
    db: Annotated[AsyncSession, Depends(get_db)],
    sessionId: str = Form(...),
    phoneNumber: str = Form(...),
    text: str = Form(""),
    serviceCode: str = Form(None),
    networkCode: str = Form(None),
):
    """
    Point d'entrée unique USSD.

    Le user compose *XXX# → on renvoie `CON WELCOME`.
    À chaque frappe, l'opérateur renvoie `text` = concaténation des choix séparés par `*`
    (ex: "1*Jean*15*1*Kinshasa*..."). On utilise une session DB pour garder l'état.
    """
    payload = USSDRequest(
        sessionId=sessionId,
        phoneNumber=phoneNumber,
        text=text,
        serviceCode=serviceCode,
        networkCode=networkCode,
    )

    # Récupère (ou crée) la session USSD
    session = await _get_session(db, payload.sessionId, payload.phoneNumber)

    # Découpe : on ne s'intéresse qu'au DERNIER segment saisi
    parts = [p for p in payload.text.split("*") if p != ""]
    last_input = parts[-1] if parts else ""

    # Si l'utilisateur a quitté (0) à n'importe quel moment
    if last_input == "0" and session.state != USSDState.WELCOME.value:
        session.state = USSDState.CANCELLED.value
        session.data = {}
        await db.commit()
        return _end("Inscription annulée. Merci d'avoir contacté le programme UNICEF.")

    state = USSDState(session.state)

    # ---------------------------------------------------------------- WELCOME
    if state == USSDState.WELCOME:
        session.state = USSDState.ASK_PRENOM.value
        await db.commit()
        return _con(
            "Bienvenue au programme UNICEF Adolescents 12-17 ans.\n"
            "1. S'inscrire\n"
            "2. Aide\n"
            "Repondez par le numero."
        )

    # ---------------------------------------------------------------- ASK_PRENOM
    if state == USSDState.ASK_PRENOM:
        if not last_input.isalpha() or len(last_input) < 2:
            return _con("Prenom invalide. Entrez votre prenom (lettres uniquement) :")
        session.data["prenom"] = _clean(last_input)
        session.state = USSDState.ASK_AGE.value
        await db.commit()
        return _con("Entrez votre age (entre 12 et 17 ans) :")

    # ---------------------------------------------------------------- ASK_AGE
    if state == USSDState.ASK_AGE:
        if not last_input.isdigit():
            return _con("Age invalide. Entrez un nombre entre 12 et 17 :")
        age = int(last_input)
        if age < 12 or age > 17:
            return _end(
                "Desole, le programme s'adresse aux adolescents de 12 a 17 ans. "
                "Merci de votre interet."
            )
        session.data["age"] = age
        session.state = USSDState.ASK_SEXE.value
        await db.commit()
        return _con("Sexe :\n1. Masculin\n2. Feminin")

    # ---------------------------------------------------------------- ASK_SEXE
    if state == USSDState.ASK_SEXE:
        if last_input not in ("1", "2"):
            return _con("Choix invalide. 1 pour Masculin, 2 pour Feminin :")
        session.data["sexe"] = "M" if last_input == "1" else "F"
        session.state = USSDState.ASK_PROVINCE.value
        await db.commit()
        return _con("Entrez votre province (ex: Kinshasa, Nord-Kivu...) :")

    # ---------------------------------------------------------------- ASK_PROVINCE
    if state == USSDState.ASK_PROVINCE:
        if len(last_input) < 3:
            return _con("Province invalide. Reessayez :")
        session.data["province"] = _clean(last_input)
        session.state = USSDState.ASK_VILLE.value
        await db.commit()
        return _con("Entrez votre ville / commune :")

    # ---------------------------------------------------------------- ASK_VILLE
    if state == USSDState.ASK_VILLE:
        if len(last_input) < 2:
            return _con("Ville invalide. Reessayez :")
        session.data["ville"] = _clean(last_input)
        session.state = USSDState.ASK_TERRITOIRE.value
        await db.commit()
        return _con("Entrez votre territoire (ou 0 pour passer) :")

    # ---------------------------------------------------------------- ASK_TERRITOIRE
    if state == USSDState.ASK_TERRITOIRE:
        session.data["territoire"] = None if last_input == "0" else _clean(last_input)
        session.state = USSDState.ASK_MILIEU.value
        await db.commit()
        return _con("Milieu :\n1. Urbain\n2. Rural")

    # ---------------------------------------------------------------- ASK_MILIEU
    if state == USSDState.ASK_MILIEU:
        if last_input not in ("1", "2"):
            return _con("Choix invalide. 1. Urbain  2. Rural :")
        session.data["milieu"] = "URBAIN" if last_input == "1" else "RURAL"
        session.state = USSDState.ASK_STATUT_SCOLAIRE.value
        await db.commit()
        return _con("Statut scolaire :\n1. Scolarise\n2. Non scolarise\n3. Decrocheur")

    # ---------------------------------------------------------------- ASK_STATUT_SCOLAIRE
    if state == USSDState.ASK_STATUT_SCOLAIRE:
        mapping = {"1": "SCOLARISE", "2": "NON_SCOLARISE", "3": "DECROCHEUR"}
        if last_input not in mapping:
            return _con("Choix invalide. 1, 2 ou 3 :")
        session.data["statut_scolaire"] = mapping[last_input]
        session.state = USSDState.ASK_HANDICAP.value
        await db.commit()
        return _con("As-tu un handicap ?\n1. Oui\n2. Non")

    # ---------------------------------------------------------------- ASK_HANDICAP
    if state == USSDState.ASK_HANDICAP:
        if last_input not in ("1", "2"):
            return _con("Choix invalide. 1. Oui  2. Non :")
        if last_input == "1":
            session.data["handicap"] = True
            session.state = USSDState.ASK_DESCRIPTION_HANDICAP.value
            await db.commit()
            return _con("Decrivez brievement votre handicap :")
        session.data["handicap"] = False
        session.data["description_handicap"] = None
        session.state = USSDState.ASK_LANGUE.value
        await db.commit()
        return _con("Langue preferee :\n1. Francais\n2. Lingala\n3. Swahili\n4. Autre")

    # ---------------------------------------------------------------- ASK_DESCRIPTION_HANDICAP
    if state == USSDState.ASK_DESCRIPTION_HANDICAP:
        session.data["description_handicap"] = _clean(last_input)
        session.state = USSDState.ASK_LANGUE.value
        await db.commit()
        return _con("Langue preferee :\n1. Francais\n2. Lingala\n3. Swahili\n4. Autre")

    # ---------------------------------------------------------------- ASK_LANGUE
    if state == USSDState.ASK_LANGUE:
        mapping = {"1": "FR", "2": "LN", "3": "SW", "4": "AUTRE"}
        if last_input not in mapping:
            return _con("Choix invalide. 1, 2, 3 ou 4 :")
        session.data["langue_preferee"] = mapping[last_input]
        session.state = USSDState.ASK_TELEPHONE.value
        await db.commit()
        return _con("Entrez votre numero de telephone (ex: 0812345678) :")

    # ---------------------------------------------------------------- ASK_TELEPHONE
    if state == USSDState.ASK_TELEPHONE:
        digits = last_input.replace("+", "").replace(" ", "")
        if not digits.isdigit() or len(digits) < 9:
            return _con("Numero invalide. Reessayez (ex: 0812345678) :")
        session.data["telephone"] = _clean(last_input)
        session.state = USSDState.ASK_TELEPHONE_PARENT.value
        await db.commit()
        return _con("Numero du parent/tuteur (pour consentement) :")

    # ---------------------------------------------------------------- ASK_TELEPHONE_PARENT
    if state == USSDState.ASK_TELEPHONE_PARENT:
        digits = last_input.replace("+", "").replace(" ", "")
        if not digits.isdigit() or len(digits) < 9:
            return _con("Numero invalide. Reessayez :")
        session.data["telephone_parent"] = _clean(last_input)
        session.state = USSDState.CONFIRM.value
        await db.commit()
        d = session.data
        return _con(
            f"Recapitulatif:\n"
            f"{d['prenom']}, {d['age']} ans, {d['sexe']}\n"
            f"{d['ville']}/{d['province']}\n"
            f"Tel parent: {d['telephone_parent']}\n"
            f"1. Confirmer\n2. Annuler"
        )

    # ---------------------------------------------------------------- CONFIRM
    if state == USSDState.CONFIRM:
        if last_input == "2":
            session.state = USSDState.CANCELLED.value
            session.data = {}
            await db.commit()
            return _end("Inscription annulee.")

        if last_input != "1":
            return _con("1. Confirmer  2. Annuler")

        try:
            ado = await _persist_adolescent(db, session.data)
        except HTTPException as exc:
            session.state = USSDState.CANCELLED.value
            await db.commit()
            return _end(exc.detail)

        session.state = USSDState.COMPLETED.value
        await db.commit()

        return _end(
            f"Inscription reussie !\n"
            f"Votre ID: {ado.id}\n"
            f"Un encadreur vous contactera bientot.\n"
            f"Merci de rejoindre le programme UNICEF."
        )

    # ---------------------------------------------------------------- fallback
    return _end("Session expiree. Veuillez recomposer le code.")
