import random
from datetime import datetime
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.models.models import (
    Adolescent, Encadreur, Club, EncadreurNotification, AuditLog,
    CanalInscriptionEnum, StatutInscriptionEnum, StatutConsentementEnum
)
from backend.app.schemas.schemas import (
    AdolescentRegistrationCreate, AdolescentResponse, ValidationInscriptionRequest,
    ClubResponse, EncadreurResponse
)
from backend.app.api.v1.auth import get_current_user_payload, require_encadreur_or_admin

router = APIRouter(prefix="/registrations", tags=["Inscriptions & Validation Encadreur"])

@router.post("", response_model=AdolescentResponse, status_code=status.HTTP_201_CREATED)
@router.post("/register", response_model=AdolescentResponse, status_code=status.HTTP_201_CREATED)
def register_adolescent(
    data: AdolescentRegistrationCreate,
    db: Session = Depends(get_db)
):
    """
    Enregistre un adolescent quel que soit le canal d'origine (USSD, Chatbot RapidPro, Web, SMS, Assisté REIPE).
    Génère un identifiant unique, associe au club local et alerte l'encadreur de proximité par notification.
    """
    # 1. Vérification stricte de l'âge (12 - 17 ans)
    if data.age < 12 or data.age > 17:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Le programme UNICEF s'adresse strictement aux adolescents âgés de 12 à 17 ans."
        )

    # 2. Génération ID unique non signifiant
    count_today = db.query(Adolescent).count() + 1
    unique_id = f"ADO-2026-{count_today:04d}"

    # 3. Recherche du Club & de l'Encadreur de proximité
    club = db.query(Club).filter(
        (Club.province.ilike(f"%{data.province}%")) & 
        (Club.ville.ilike(f"%{data.ville}%"))
    ).first()

    if not club:
        # Fallback sur un club de la province
        club = db.query(Club).filter(Club.province.ilike(f"%{data.province}%")).first()

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
        date_inscription=datetime.utcnow()
    )
    db.add(ado)
    db.flush()

    # 5. Création de la Notification Détaillée pour l'Encadreur Référent
    canal_label = data.canal_inscription.value
    titre_notif = f"Nouvelle inscription {canal_label} : {ado.prenom} ({ado.age} ans, {ado.sexe})"
    handicap_info = f" • Handicap: {ado.description_handicap}" if ado.handicap else ""
    message_notif = (
        f"L'adolescent(e) {ado.prenom} ({ado.age} ans, sexe: {ado.sexe}, {ado.ville}/{ado.province}, "
        f"milieu: {ado.milieu}, statut: {ado.statut_scolaire}{handicap_info}) souhaite rejoindre "
        f"{club.nom if club else 'le réseau'}. Canal d'origine : {canal_label}. "
        f"Contact Parent pour consentement : {ado.telephone_parent}."
    )

    notif = EncadreurNotification(
        id=f"NOTIF-{datetime.utcnow().strftime('%Y%m%d%H%M%S')}-{random.randint(100, 999)}",
        encadreur_id=encadreur_id,
        adolescent_id=ado.id,
        type_notification="NOUVELLE_INSCRIPTION",
        titre=titre_notif,
        message=message_notif,
        is_read=False,
        created_at=datetime.utcnow()
    )
    db.add(notif)

    # 6. Journal d'audit
    db.add(AuditLog(
        user_id=ado.id,
        user_role="ADOLESCENT",
        action="INSCRIPTION_CANAL",
        details=f"Inscription de {ado.prenom} via canal {canal_label} (Zone: {ado.province}/{ado.ville}, Sexe: {ado.sexe})"
    ))

    db.commit()
    db.refresh(ado)
    return ado

@router.get("/pending", response_model=List[AdolescentResponse])
def get_pending_registrations(
    province: Optional[str] = None,
    canal: Optional[CanalInscriptionEnum] = None,
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    """
    Récupère la file d'attente des inscriptions à valider par l'encadreur.
    Cloisonné à la zone de l'encadreur ou filtrable par l'administrateur.
    """
    query = db.query(Adolescent).filter(
        Adolescent.statut_inscription == StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION
    )

    # Si encadreur connecté : restreindre à sa province ou ses clubs
    if current_user.get("role") == "ENCADREUR":
        enc_id = current_user.get("sub")
        enc = db.query(Encadreur).filter(Encadreur.id == enc_id).first()
        if enc:
            query = query.filter(Adolescent.province.ilike(f"%{enc.province}%"))
    elif province:
        query = query.filter(Adolescent.province.ilike(f"%{province}%"))

    if canal:
        query = query.filter(Adolescent.canal_inscription == canal)

    return query.order_by(Adolescent.date_inscription.desc()).all()

@router.post("/{adolescent_id}/validate", response_model=AdolescentResponse)
def validate_adolescent_registration(
    adolescent_id: str,
    validation: ValidationInscriptionRequest,
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    """
    L'encadreur confirme ou rejette l'inscription de l'adolescent.
    Une fois confirmée, la demande de consentement parental est automatiquement routée.
    """
    ado = db.query(Adolescent).filter(Adolescent.id == adolescent_id).first()
    if not ado:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Dossier adolescent introuvable.")

    ado.statut_inscription = validation.statut
    ado.date_validation_encadreur = datetime.utcnow()

    # Si confirmée, simulation de déclenchement du consentement parental
    if validation.statut == StatutInscriptionEnum.CONFIRMED:
        ado.statut_consentement = StatutConsentementEnum.EN_ATTENTE

    # Audit
    db.add(AuditLog(
        user_id=current_user.get("sub"),
        user_role=current_user.get("role"),
        action="VALIDATION_INSCRIPTION",
        details=f"Inscription de {ado.prenom} ({ado.id}) passée à {validation.statut.value} par l'encadreur {current_user.get('sub')}"
    ))

    db.commit()
    db.refresh(ado)
    return ado

@router.post("/{adolescent_id}/consent", response_model=AdolescentResponse)
def update_parental_consent(
    adolescent_id: str,
    statut_consentement: StatutConsentementEnum,
    mode: str = "WhatsApp / SMS RapidPro",
    db: Session = Depends(get_db)
):
    """
    Enregistre la réponse parentale (Accord, Refus, ou Révocation).
    """
    ado = db.query(Adolescent).filter(Adolescent.id == adolescent_id).first()
    if not ado:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable.")

    ado.statut_consentement = statut_consentement
    ado.mode_consentement = mode

    if statut_consentement == StatutConsentementEnum.REVOQUE:
        ado.anonymise = True
        ado.prenom = f"Anonyme_{ado.id[-4:]}"

    db.add(AuditLog(
        user_id=ado.id,
        user_role="PARENT",
        action="REPONSE_CONSENTEMENT",
        details=f"Consentement parental mis à jour: {statut_consentement.value} via {mode}"
    ))

    db.commit()
    db.refresh(ado)
    return ado

@router.get("", response_model=List[AdolescentResponse])
def get_all_adolescents(
    province: Optional[str] = None,
    statut: Optional[StatutInscriptionEnum] = None,
    db: Session = Depends(get_db)
):
    """
    Récupère la liste de tous les adolescents inscrits avec filtres optionnels.
    """
    query = db.query(Adolescent)
    if province:
        query = query.filter(Adolescent.province.ilike(f"%{province}%"))
    if statut:
        query = query.filter(Adolescent.statut_inscription == statut)
    return query.order_by(Adolescent.date_inscription.desc()).all()

@router.get("/meta/clubs", response_model=List[ClubResponse])
def get_all_clubs(db: Session = Depends(get_db)):
    """
    Retourne la liste des clubs d'engagement.
    """
    clubs = db.query(Club).all()
    return clubs

@router.get("/meta/encadreurs", response_model=List[EncadreurResponse])
def get_all_encadreurs(db: Session = Depends(get_db)):
    """
    Retourne la liste des encadreurs de proximité.
    """
    encadreurs = db.query(Encadreur).all()
    return encadreurs

@router.get("/{adolescent_id}", response_model=AdolescentResponse)
def get_adolescent_by_id(adolescent_id: str, db: Session = Depends(get_db)):
    """
    Récupère les informations détaillées d'un adolescent.
    """
    ado = db.query(Adolescent).filter(Adolescent.id == adolescent_id).first()
    if not ado:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable.")
    return ado

@router.post("/confirm/{adolescent_id}", response_model=AdolescentResponse)
def confirm_adolescent_direct(
    adolescent_id: str,
    db: Session = Depends(get_db)
):
    """
    Confirme directement l'inscription d'un adolescent.
    """
    ado = db.query(Adolescent).filter(Adolescent.id == adolescent_id).first()
    if not ado:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable.")

    ado.statut_inscription = StatutInscriptionEnum.CONFIRMED
    ado.date_validation_encadreur = datetime.utcnow()
    ado.statut_consentement = StatutConsentementEnum.EN_ATTENTE

    db.add(AuditLog(
        user_id=ado.id,
        user_role="ENCADREUR",
        action="CONFIRMATION_DIRECTE",
        details=f"Inscription de {ado.prenom} ({ado.id}) confirmée avec succès."
    ))

    db.commit()
    db.refresh(ado)
    return ado
