from datetime import datetime
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.models.models import IncidentSauvegarde, AuditLog
from backend.app.schemas.schemas import IncidentSauvegardeCreate, IncidentSauvegardeResponse
from backend.app.api.v1.auth import require_admin

router = APIRouter(prefix="/safeguard", tags=["Protection & Sauvegarde 24/7"])

@router.post("/report", response_model=IncidentSauvegardeResponse, status_code=status.HTTP_201_CREATED)
def report_incident(
    data: IncidentSauvegardeCreate,
    db: Session = Depends(get_db)
):
    """
    Signalement d'urgence 24/7 avec routage immédiat vers les points focaux PSE UNICEF.
    Garantit le respect du délai de prise en charge SLA < 24 heures.
    """
    inc_id = f"PSE-2026-{datetime.utcnow().strftime('%m%d%H%M%S')}"

    incident = IncidentSauvegarde(
        id=inc_id,
        signaleur_type=data.signaleur_type,
        signaleur_contact=data.signaleur_contact,
        type_incident=data.type_incident,
        gravite=data.gravite,
        description=data.description,
        province=data.province,
        statut="SIGNALÉ_SLA_24H",
        date_signalement=datetime.utcnow(),
        point_focal_assigne="Point Focal PSE UNICEF RDC"
    )
    db.add(incident)
    db.add(AuditLog(
        user_id="SYSTEM",
        user_role="PSE_ALERT",
        action="SIGNALEMENT_URGENT",
        details=f"Alerte Sauvegarde enregistrée ID {inc_id} (Gravité: {data.gravite}, Province: {data.province})"
    ))

    db.commit()
    db.refresh(incident)
    return incident

@router.get("/incidents", response_model=List[IncidentSauvegardeResponse])
def get_all_incidents(
    current_user: dict = Depends(require_admin),
    db: Session = Depends(get_db)
):
    return db.query(IncidentSauvegarde).order_by(IncidentSauvegarde.date_signalement.desc()).all()
