from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import (
    Adolescent,
    AuditLog,
    CanalInscriptionEnum,
    Club,
    EncadreurNotification,
    StatutConsentementEnum,
    StatutInscriptionEnum,
)
from ...schemas.schemas import AdolescentResponse

router = APIRouter(prefix="/rapidpro", tags=["Intégration RapidPro & Canaux Télécoms"])


class RapidProWebhookPayload(BaseModel):
    contact_urn: str = Field(
        ..., description="ex: tel:+243812345678 ou whatsapp:243812345678"
    )
    flow_id: str = Field(default="flow-unicef-inscription-v1")
    prenom: str
    age: int
    sexe: str
    province: str
    ville: str
    telephone_parent: str
    langue: str = "Lingála"
    milieu: str = "Urbain"
    statut_scolaire: str = "Scolarisé"


class USSDSessionRequest(BaseModel):
    session_id: str
    phone_number: str
    ussd_string: str = Field(
        ..., description="ex: *120*243*1*Esther*15*F*Kinshasa*Nsele*0811110002#"
    )


@router.post("/webhook", response_model=AdolescentResponse)
async def rapidpro_webhook_handler(
    payload: RapidProWebhookPayload, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Webhook officiel appelé par l'instance RapidPro (U-Report) lorsque le flux WhatsApp
    ou SMS d'inscription d'un adolescent est complété.
    """
    clean_phone = (
        payload.contact_urn.replace("tel:", "").replace("whatsapp:", "").strip()
    )

    # 1. Validation de l'âge
    if payload.age < 12 or payload.age > 17:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Âge inéligible : le programme UNICEF concerne les 12-17 ans.",
        )

    # 2. Vérification existence
    existing = (
        (
            await db.execute(
                select(Adolescent).where(Adolescent.telephone == clean_phone)
            )
        )
        .scalars()
        .first()
    )
    if existing:
        return existing

    # 3. Association Club et Encadreur
    club = (
        (
            await db.execute(
                select(Club).where(
                    (Club.province.ilike(f"%{payload.province}%"))
                    & (Club.ville.ilike(f"%{payload.ville}%"))
                )
            )
        )
        .scalars()
        .first()
    )
    if not club:
        club = (
            (
                await db.execute(
                    select(Club).where(Club.province.ilike(f"%{payload.province}%"))
                )
            )
            .scalars()
            .first()
        )

    club_id = club.id if club else None
    encadreur_id = club.encadreur_id if (club and club.encadreur_id) else "ENC-KIN-01"

    count_all = (
        (await db.execute(select(func.count(Adolescent.id)))).scalar() or 0
    ) + 1
    ado_id = f"ADO-2026-{count_all:04d}"

    canal = (
        CanalInscriptionEnum.CHATBOT_RAPIDPRO
        if "whatsapp" in payload.contact_urn.lower()
        else CanalInscriptionEnum.SMS
    )

    ado = Adolescent(
        id=ado_id,
        prenom=payload.prenom.strip(),
        age=payload.age,
        sexe=payload.sexe.upper(),
        province=payload.province.strip(),
        ville=payload.ville.strip(),
        milieu=payload.milieu,
        statut_scolaire=payload.statut_scolaire,
        handicap=False,
        langue_preferee=payload.langue,
        telephone=clean_phone,
        telephone_parent=payload.telephone_parent.strip(),
        club_id=club_id,
        canal_inscription=canal,
        statut_inscription=StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION,
        statut_consentement=StatutConsentementEnum.EN_ATTENTE,
        points_xp=50,
        certifie=False,
        date_inscription=datetime.now(),
    )
    db.add(ado)
    await db.flush()

    # Notification Encadreur
    notif = EncadreurNotification(
        id=f"NOTIF-{datetime.now().strftime('%Y%m%d%H%M%S')}-RP",
        encadreur_id=encadreur_id,
        adolescent_id=ado.id,
        type_notification="NOUVELLE_INSCRIPTION",
        titre=f"Nouvelle inscription RapidPro ({canal.value}) : {ado.prenom} ({ado.age} ans)",
        message=f"Inscription reçue via RapidPro pour {ado.prenom} ({ado.sexe}, {ado.ville}/{ado.province}). Contact parent: {ado.telephone_parent}.",
        is_read=False,
        created_at=datetime.now(),
    )
    db.add(notif)
    db.add(
        AuditLog(
            user_id=ado.id,
            user_role="RAPIDPRO_WEBHOOK",
            action="WEBHOOK_INSCRIPTION",
            details=f"Inscription automatique via RapidPro webhook ({canal.value}) de {ado.prenom}",
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado


@router.post("/simulate-ussd")
async def simulate_ussd_session(
    request: USSDSessionRequest, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Simule la passerelle USSD des opérateurs télécoms (Vodacom, Airtel, Orange, Africell).
    Format attendu : *120*243*1*<Prenom>*<Age>*<Sexe>*<Province>*<Ville>*<TelParent>#
    """
    raw = request.ussd_string.replace("*120*243*", "").replace("#", "")
    parts = raw.split("*")

    if len(parts) < 7:
        return {
            "ussd_response": "CON Bienvenue sur BanApp RDC !\n1. Entrez: Prenom*Age*Sexe(F/M)*Province*Ville*TelParent",
            "action": "CONTINUE",
        }

    try:
        _, prenom, age_str, sexe, province, ville, tel_parent = parts[:7]
        age = int(age_str)
    except Exception:
        return {
            "ussd_response": "END Format invalide. Exemple: *120*243*1*Esther*15*F*Kinshasa*Nsele*0811110002#",
            "action": "END",
        }

    if age < 12 or age > 17:
        return {
            "ussd_response": "END Désolé, ce programme est réservé aux 12-17 ans.",
            "action": "END",
        }

    # Création du dossier

    count_all = (
        (await db.execute(select(func.count(Adolescent.id)))).scalar() or 0
    ) + 1
    ado_id = f"ADO-2026-{count_all:04d}"

    club = (
        (await db.execute(select(Club).where(Club.province.ilike(f"%{province}%"))))
        .scalars()
        .first()
    )
    enc_id = club.encadreur_id if (club and club.encadreur_id) else "ENC-KIN-01"

    ado = Adolescent(
        id=ado_id,
        prenom=prenom.strip(),
        age=age,
        sexe=sexe.upper(),
        province=province.strip(),
        ville=ville.strip(),
        milieu="Péri-urbain",
        statut_scolaire="Scolarisé",
        handicap=False,
        langue_preferee="Français",
        telephone=request.phone_number,
        telephone_parent=tel_parent.strip(),
        club_id=club.id if club else None,
        canal_inscription=CanalInscriptionEnum.USSD,
        statut_inscription=StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION,
        statut_consentement=StatutConsentementEnum.EN_ATTENTE,
        points_xp=50,
        certifie=False,
        date_inscription=datetime.now(),
    )
    db.add(ado)
    await db.flush()

    notif = EncadreurNotification(
        id=f"NOTIF-{datetime.now().strftime('%Y%m%d%H%M%S')}-USSD",
        encadreur_id=enc_id,
        adolescent_id=ado.id,
        type_notification="NOUVELLE_INSCRIPTION",
        titre=f"Inscription USSD à valider : {ado.prenom} ({ado.age} ans, {ado.sexe})",
        message=f"{ado.prenom} ({ado.ville}/{ado.province}) s'est inscrit via USSD. Contact Parent: {ado.telephone_parent}.",
        is_read=False,
        created_at=datetime.now(),
    )
    db.add(notif)
    await db.commit()

    return {
        "ussd_response": f"END Inscription réussie ! Votre ID est {ado_id}. Votre encadreur local va valider votre dossier.",
        "action": "END",
        "adolescent_id": ado_id,
    }
