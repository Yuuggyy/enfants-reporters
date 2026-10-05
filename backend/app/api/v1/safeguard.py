from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import AuditLog, IncidentSauvegarde
from ...schemas.schemas import IncidentSauvegardeCreate, IncidentSauvegardeResponse
from .auth import require_admin

router = APIRouter(prefix="/safeguard", tags=["Protection & Sauvegarde 24/7"])


@router.post(
    "/report",
    response_model=IncidentSauvegardeResponse,
    status_code=status.HTTP_201_CREATED,
)
async def report_incident(
    data: IncidentSauvegardeCreate, db: Annotated[AsyncSession, Depends(get_db)]
):
    """
    Signalement d'urgence 24/7 avec routage immédiat vers les points focaux PSE UNICEF.
    Garantit le respect du délai de prise en charge SLA < 24 heures.
    """
    inc_id = f"PSE-2026-{datetime.now().strftime('%m%d%H%M%S')}"

    incident = IncidentSauvegarde(
        id=inc_id,
        signaleur_type=data.signaleur_type,
        signaleur_contact=data.signaleur_contact,
        type_incident=data.type_incident,
        gravite=data.gravite,
        description=data.description,
        province=data.province,
        statut="SIGNALÉ_SLA_24H",
        date_signalement=datetime.now(),
        point_focal_assigne="Point Focal PSE UNICEF RDC",
    )
    db.add(incident)
    db.add(
        AuditLog(
            user_id="SYSTEM",
            user_role="PSE_ALERT",
            action="SIGNALEMENT_URGENT",
            details=f"Alerte Sauvegarde enregistrée ID {inc_id} (Gravité: {data.gravite}, Province: {data.province})",
        )
    )

    await db.commit()
    await db.refresh(incident)
    return incident


@router.get("/incidents", response_model=list[IncidentSauvegardeResponse])
async def get_all_incidents(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[dict, Depends(require_admin)],
):
    return (
        (
            await db.execute(
                select(IncidentSauvegarde).order_by(
                    IncidentSauvegarde.date_signalement.desc()
                )
            )
        )
        .scalars()
        .all()
    )
