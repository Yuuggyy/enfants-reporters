import random
from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import (
    Adolescent,
    AuditLog,
    CanalInscriptionEnum,
    Club,
    Encadreur,
    EncadreurNotification,
    StatutConsentementEnum,
    StatutInscriptionEnum,
)
from ...schemas.schemas import (
    AdolescentRegistrationCreate,
    AdolescentResponse,
    ClubResponse,
    EncadreurResponse,
    ValidationInscriptionRequest,
)
from .auth import require_encadreur_or_admin

router = APIRouter(
    prefix="/registrations", tags=["Inscriptions & Validation Encadreur"]
)


@router.post(
    "/register", response_model=AdolescentResponse, status_code=status.HTTP_201_CREATED
)
async def register_adolescent(
    data: AdolescentRegistrationCreate, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Enregistre un adolescent quel que soit le canal d'origine (USSD, Chatbot RapidPro, Web, SMS, Assisté REIPE).
    Génère un identifiant unique, associe au club local et alerte l'encadreur de proximité par notification.
    """
    # 1. Vérification stricte de l'âge (12 - 17 ans)
    if data.age < 12 or data.age > 17:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Le programme UNICEF s'adresse strictement aux adolescents âgés de 12 à 17 ans.",
        )

    # 2. Génération ID unique non signifiant
    result1 = await db.execute(select(func.count()).select_from(Adolescent))
    next_id = (result1.scalar() or 0) + 1
    now = datetime.now()
    unique_id = f"ADO-{now.year}-{next_id:04d}"

    # 3. Recherche du Club & de l'Encadreur de proximité
    stmt = (
        select(Club)
        .where(
            Club.province.ilike(f"%{data.province}%"),
            Club.ville.ilike(f"%{data.ville}%"),
        )
        .limit(1)
    )

    result1 = await db.execute(stmt)
    club = result1.scalars().first()

    if not club:
        # Fallback sur un club de la province
        stmt = select(Club).where(Club.province.ilike(f"%{data.province}%")).limit(1)

        result = await db.execute(stmt)
        club = result.scalars().first()

    club_id = club.id if club else None
    encadreur_id = club.encadreur_id if (club and club.encadreur_id) else "ENC-KIN-01"

    # 4. Création du dossier Adolescent
    nouveau_statut = (
        StatutInscriptionEnum.CONFIRMED
        if data.canal_inscription == CanalInscriptionEnum.ASSISTED_REIPE
        else StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION
    )

    ado = Adolescent(
        id=unique_id,
        prenom=data.prenom.strip(),
        age=data.age,
        sexe=data.sexe.upper(),
        province=data.province.strip(),
        ville=data.ville.strip(),
        territoire=data.territoire.strip() if data.territoire else None,
        milieu=data.milieu,
        statut_scolaire=data.statut_scolaire,
        handicap=data.handicap,
        description_handicap=data.description_handicap,
        langue_preferee=data.langue_preferee,
        telephone=data.telephone.strip(),
        telephone_parent=data.telephone_parent.strip(),
        club_id=club_id,
        canal_inscription=data.canal_inscription,
        statut_inscription=nouveau_statut,
        statut_consentement=StatutConsentementEnum.EN_ATTENTE,
        mode_consentement="SMS / WhatsApp RapidPro",
        points_xp=50,
        certifie=False,
        date_inscription=datetime.now(),
    )
    db.add(ado)
    await db.flush()

    # 5. Création de la Notification Détaillée pour l'Encadreur Référent
    canal_label = data.canal_inscription.value
    titre_notif = (
        f"Nouvelle inscription {canal_label} : {ado.prenom} ({ado.age} ans, {ado.sexe})"
    )
    handicap_info = (
        f" • Handicap: {ado.description_handicap}"
        if ado.handicap
        else "Pas d'handicap signalé"
    )
    message_notif = (
        f"L'adolescent(e) {ado.prenom} ({ado.age} ans, sexe: {ado.sexe}, {ado.ville}/{ado.province}, "
        f"milieu: {ado.milieu}, statut: {ado.statut_scolaire}{handicap_info}) souhaite rejoindre "
        f"{club.nom if club else 'le réseau'}. Canal d'origine : {canal_label}. "
        f"Contact Parent pour consentement : {ado.telephone_parent}."
    )

    notif = EncadreurNotification(
        id=f"NOTIF-{datetime.now().strftime('%Y%m%d%H%M%S')}-{random.randint(100, 999)}",
        encadreur_id=encadreur_id,
        adolescent_id=ado.id,
        type_notification="NOUVELLE_INSCRIPTION",
        titre=titre_notif,
        message=message_notif,
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
            details=f"Inscription de {ado.prenom} via canal {canal_label} (Zone: {ado.province}/{ado.ville}, Sexe: {ado.sexe})",
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado


@router.get("/pending", response_model=list[AdolescentResponse])
async def get_pending_registrations(
    province: str | None,
    canal: CanalInscriptionEnum | None,
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Récupère la file d'attente des inscriptions à valider par l'encadreur.
    Cloisonné à la zone de l'encadreur ou filtrable par l'administrateur.
    """
    # 1. Requête de base
    stmt = select(Adolescent).where(
        Adolescent.statut_inscription
        == StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION
    )
    # 2. Si encadreur connecté : restreindre à sa province
    if current_user.get("role") == "ENCADREUR":
        enc_id = current_user.get("sub")

        # Requête pour récupérer l'encadreur
        enc_stmt = select(Encadreur).where(Encadreur.id == enc_id).limit(1)
        enc_result = await db.execute(enc_stmt)
        enc = enc_result.scalars().first()

        if enc:
            stmt = stmt.where(Adolescent.province.ilike(f"%{enc.province}%"))
    elif province:
        stmt = stmt.where(Adolescent.province.ilike(f"%{province}%"))

    # 3. Filtre sur le canal
    if canal:
        stmt = stmt.where(Adolescent.canal_inscription == canal)

    # 4. Tri et exécution
    stmt = stmt.order_by(Adolescent.date_inscription.desc())
    result = await db.execute(stmt)
    return result.scalars().all()


@router.post("/{adolescent_id}/validate", response_model=AdolescentResponse)
async def validate_adolescent_registration(
    adolescent_id: str,
    validation: ValidationInscriptionRequest,
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    L'encadreur confirme ou rejette l'inscription de l'adolescent.
    Une fois confirmée, la demande de consentement parental est automatiquement routée.
    """
    stmt = select(Adolescent).where(Adolescent.id == adolescent_id)
    result = await db.execute(stmt)
    ado = result.scalars().first()
    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Dossier adolescent introuvable.",
        )

    ado.statut_inscription = validation.statut
    ado.date_validation_encadreur = datetime.now()

    # Si confirmée, simulation de déclenchement du consentement parental
    if validation.statut == StatutInscriptionEnum.CONFIRMED:
        ado.statut_consentement = StatutConsentementEnum.EN_ATTENTE

    # Audit
    db.add(
        AuditLog(
            user_id=current_user.get("sub"),
            user_role=current_user.get("role"),
            action="VALIDATION_INSCRIPTION",
            details=f"Inscription de {ado.prenom} ({ado.id}) passée à {validation.statut.value} par l'encadreur {current_user.get('sub')}",
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado


@router.post("/{adolescent_id}/consent", response_model=AdolescentResponse)
async def update_parental_consent(
    adolescent_id: str,
    statut_consentement: StatutConsentementEnum,
    db: Annotated[AsyncSession, Depends(get_db)],
    mode: str = "WhatsApp / SMS RapidPro",
):
    """
    Enregistre la réponse parentale (Accord, Refus, ou Révocation).
    """
    stmt = select(Adolescent).where(Adolescent.id == adolescent_id)
    result = await db.execute(stmt)
    ado = result.scalars().first()

    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable."
        )

    ado.statut_consentement = statut_consentement
    ado.mode_consentement = mode

    if statut_consentement == StatutConsentementEnum.REVOQUE:
        ado.anonymise = True
        ado.prenom = f"Anonyme_{ado.id[-4:]}"

    db.add(
        AuditLog(
            user_id=ado.id,
            user_role="PARENT",
            action="REPONSE_CONSENTEMENT",
            details=f"Consentement parental mis à jour: {statut_consentement.value} via {mode}",
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado


@router.get("", response_model=list[AdolescentResponse])
async def get_all_adolescents(
    province: str | None,
    statut: StatutInscriptionEnum | None,
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Récupère la liste de tous les adolescents inscrits avec filtres optionnels.
    """
    stmt = select(Adolescent)
    if province:
        stmt = stmt.where(Adolescent.province.ilike(f"%{province}%"))
    if statut:
        stmt = stmt.where(Adolescent.statut_inscription == statut)
    result = await db.execute(stmt.order_by(Adolescent.date_inscription.desc()))
    return result.scalars().all()


@router.get("/meta/clubs", response_model=list[ClubResponse])
async def get_all_clubs(db: Annotated[AsyncSession, Depends(get_db)]):
    """
    Retourne la liste des clubs d'engagement.
    """
    result = await db.execute(select(Club).order_by(Club.nom))
    clubs = result.scalars().all()
    return clubs


@router.get("/meta/encadreurs", response_model=list[EncadreurResponse])
async def get_all_encadreurs(db: Annotated[AsyncSession, Depends(get_db)]):
    """
    Retourne la liste des encadreurs de proximité.
    """
    result = await db.execute(select(Encadreur).order_by(Encadreur.nom))
    encadreurs = result.scalars().all()
    return encadreurs


@router.get("/{adolescent_id}", response_model=AdolescentResponse)
async def get_adolescent_by_id(
    adolescent_id: str, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Récupère les informations détaillées d'un adolescent.
    """
    stmt = select(Adolescent).where(Adolescent.id == adolescent_id).limit(1)

    result = await db.execute(stmt)
    ado = result.scalars().first()
    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable."
        )
    return ado


@router.post("/confirm/{adolescent_id}", response_model=AdolescentResponse)
async def confirm_adolescent_direct(
    adolescent_id: str, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Confirme directement l'inscription d'un adolescent.
    """
    stmt = select(Adolescent).where(Adolescent.id == adolescent_id).limit(1)

    result = await db.execute(stmt)
    ado = result.scalars().first()
    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable."
        )

    ado.statut_inscription = StatutInscriptionEnum.CONFIRMED
    ado.date_validation_encadreur = datetime.now()
    ado.statut_consentement = StatutConsentementEnum.EN_ATTENTE

    db.add(
        AuditLog(
            user_id=ado.id,
            user_role="ENCADREUR",
            action="CONFIRMATION_DIRECTE",
            details=f"Inscription de {ado.prenom} ({ado.id}) confirmée avec succès.",
        )
    )

    await db.commit()
    await db.refresh(ado)
    return ado
