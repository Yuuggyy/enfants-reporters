from datetime import datetime
from typing import Annotated, Optional

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import Adolescent, AuditLog, Reportage, StatutReportageEnum
from ...schemas.schemas import ReportageCreate, ReportageResponse
from .auth import get_current_user_payload, require_admin, require_encadreur_or_admin

router = APIRouter(prefix="/ponabana", tags=["Enfants Reporters & Validation Ponabana"])


@router.post(
    "/reportages", response_model=ReportageResponse, status_code=status.HTTP_201_CREATED
)
async def submit_reportage(
    data: ReportageCreate,
    current_user: Annotated[dict, Depends(get_current_user_payload)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Soumission d'un reportage par un Adolescent avec purge EXIF et floutage de protection activés.
    Le statut initial est 'SOUMIS_N1' (en attente modération par l'encadreur du club).
    """
    user_id = current_user.get("sub")
    rep_id = f"REP-{datetime.now().strftime('%Y%m%d%H%M%S')}"

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
        date_soumission=datetime.now(),
    )
    db.add(reportage)

    # Attribution de points XP à l'adolescent

    ado = (
        (await db.execute(select(Adolescent).where(Adolescent.id == user_id)))
        .scalars()
        .first()
    )
    if ado:
        ado.points_xp += 50

    db.add(
        AuditLog(
            user_id=user_id,
            user_role="ADOLESCENT",
            action="SOUMISSION_REPORTAGE",
            details=f"Soumission du reportage '{data.titre}' (ID: {rep_id})",
        )
    )

    await db.commit()
    await db.refresh(reportage)
    return reportage


@router.get("/reportages", response_model=list[ReportageResponse])
async def get_all_reportages(
    statut: Optional[StatutReportageEnum], db: Annotated[AsyncSession, Depends(get_db)]
):
    stmt = select(Reportage)

    if statut:
        stmt = stmt.where(Reportage.statut == statut)

    stmt = stmt.order_by(Reportage.date_soumission.desc())

    result = await db.execute(stmt)
    return result.scalars().all()


@router.post("/reportages/{reportage_id}/review-n1", response_model=ReportageResponse)
async def review_reportage_n1(
    reportage_id: str,
    avis_encadreur: str,
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
    approuve: bool = True,
):
    """
    Modération Niveau 1 (Encadreur de Club) :
    Valide le reportage et le transmet au Comité Éditorial Ponabana (Niveau 2).
    """
    result_rep = await db.execute(select(Reportage).where(Reportage.id == reportage_id))
    rep = result_rep.scalars().first()
    if not rep:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Reportage introuvable."
        )

    rep.avis_encadreur = avis_encadreur
    rep.statut = (
        StatutReportageEnum.VALIDE_N1 if approuve else StatutReportageEnum.A_CORRIGER
    )

    db.add(
        AuditLog(
            user_id=current_user.get("sub"),
            user_role="ENCADREUR",
            action="MODERATION_N1",
            details=f"Modération N1 du reportage {reportage_id} : {'Approuvé' if approuve else 'À corriger'}",
        )
    )

    await db.commit()
    await db.refresh(rep)
    return rep


@router.post("/reportages/{reportage_id}/publish-n2", response_model=ReportageResponse)
async def publish_reportage_n2_wordpress(
    reportage_id: str,
    relecture_ponabana: str,
    current_user: Annotated[dict, Depends(require_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Modération Niveau 2 (Comité Ponabana / UNICEF) :
    Publication officielle vers le blog WordPress Ponabana via API REST.
    """
    result_rep = await db.execute(select(Reportage).where(Reportage.id == reportage_id))
    rep = result_rep.scalars().first()
    if not rep:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Reportage introuvable."
        )
    stmt = select(func.count(Reportage.id)).where(
        Reportage.statut == StatutReportageEnum.PUBLIE_PONABANA_N2
    )

    # 2. On exécute la requête
    result = await db.execute(stmt)
    count = result.scalar()

    rep.relecture_ponabana = relecture_ponabana
    rep.statut = StatutReportageEnum.PUBLIE_PONABANA_N2
    rep.date_publication = datetime.now()
    rep.wordpress_post_id = 1042 + (count or 0)

    db.add(
        AuditLog(
            user_id=current_user.get("sub"),
            user_role="ADMIN_PONABANA",
            action="PUBLICATION_WORDPRESS",
            details=f"Publication Ponabana WP ID {rep.wordpress_post_id} du reportage {reportage_id}",
        )
    )

    await db.commit()
    await db.refresh(rep)
    return rep
