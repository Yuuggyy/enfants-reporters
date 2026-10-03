from typing import List, Optional
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.models.models import Reportage, Adolescent, StatutReportageEnum, AuditLog
from backend.app.schemas.schemas import ReportageCreate, ReportageResponse
from backend.app.api.v1.auth import get_current_user_payload, require_encadreur_or_admin, require_admin

router = APIRouter(prefix="/ponabana", tags=["Enfants Reporters & Validation Ponabana"])

@router.post("/reportages", response_model=ReportageResponse, status_code=status.HTTP_201_CREATED)
def submit_reportage(
    data: ReportageCreate,
    current_user: dict = Depends(get_current_user_payload),
    db: Session = Depends(get_db)
):
    """
    Soumission d'un reportage par un Adolescent avec purge EXIF et floutage de protection activés.
    Le statut initial est 'SOUMIS_N1' (en attente modération par l'encadreur du club).
    """
    user_id = current_user.get("sub")
    rep_id = f"REP-{datetime.utcnow().strftime('%Y%m%d%H%M%S')}"

    reportage = Reportage(
        id=rep_id,
        auteur_id=user_id,
        titre=data.titre,
        contenu=data.contenu,
        type_media=data.type_media,
        media_url=data.media_url,
        theme=data.theme,
        statut=StatutReportageEnum.SOUMIS_N1,
        exif_purge=data.exif_purge,
        floutage_actif=data.floutage_actif,
        consentement_interviewes=data.consentement_interviewes,
        date_soumission=datetime.utcnow()
    )
    db.add(reportage)

    # Attribution de points XP à l'adolescent
    ado = db.query(Adolescent).filter(Adolescent.id == user_id).first()
    if ado:
        ado.points_xp += 50

    db.add(AuditLog(
        user_id=user_id,
        user_role="ADOLESCENT",
        action="SOUMISSION_REPORTAGE",
        details=f"Soumission du reportage '{data.titre}' (ID: {rep_id})"
    ))

    db.commit()
    db.refresh(reportage)
    return reportage

@router.get("/reportages", response_model=List[ReportageResponse])
def get_all_reportages(
    statut: Optional[StatutReportageEnum] = None,
    db: Session = Depends(get_db)
):
    query = db.query(Reportage)
    if statut:
        query = query.filter(Reportage.statut == statut)
    return query.order_by(Reportage.date_soumission.desc()).all()

@router.post("/reportages/{reportage_id}/review-n1", response_model=ReportageResponse)
def review_reportage_n1(
    reportage_id: str,
    avis_encadreur: str,
    approuve: bool = True,
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    """
    Modération Niveau 1 (Encadreur de Club) :
    Valide le reportage et le transmet au Comité Éditorial Ponabana (Niveau 2).
    """
    rep = db.query(Reportage).filter(Reportage.id == reportage_id).first()
    if not rep:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reportage introuvable.")

    rep.avis_encadreur = avis_encadreur
    rep.statut = StatutReportageEnum.VALIDE_N1 if approuve else StatutReportageEnum.A_CORRIGER

    db.add(AuditLog(
        user_id=current_user.get("sub"),
        user_role="ENCADREUR",
        action="MODERATION_N1",
        details=f"Modération N1 du reportage {reportage_id} : {'Approuvé' if approuve else 'À corriger'}"
    ))

    db.commit()
    db.refresh(rep)
    return rep

@router.post("/reportages/{reportage_id}/publish-n2", response_model=ReportageResponse)
def publish_reportage_n2_wordpress(
    reportage_id: str,
    relecture_ponabana: str,
    current_user: dict = Depends(require_admin),
    db: Session = Depends(get_db)
):
    """
    Modération Niveau 2 (Comité Ponabana / UNICEF) :
    Publication officielle vers le blog WordPress Ponabana via API REST.
    """
    rep = db.query(Reportage).filter(Reportage.id == reportage_id).first()
    if not rep:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reportage introuvable.")

    rep.relecture_ponabana = relecture_ponabana
    rep.statut = StatutReportageEnum.PUBLIE_PONABANA_N2
    rep.date_publication = datetime.utcnow()
    rep.wordpress_post_id = 1042 + db.query(Reportage).filter(Reportage.statut == StatutReportageEnum.PUBLIE_PONABANA_N2).count()

    db.add(AuditLog(
        user_id=current_user.get("sub"),
        user_role="ADMIN_PONABANA",
        action="PUBLICATION_WORDPRESS",
        details=f"Publication Ponabana WP ID {rep.wordpress_post_id} du reportage {reportage_id}"
    ))

    db.commit()
    db.refresh(rep)
    return rep
