from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import Adolescent, EncadreurNotification
from ...schemas.schemas import EncadreurNotificationResponse
from .auth import require_encadreur_or_admin

router = APIRouter(prefix="/notifications", tags=["Notifications Encadreur"])


@router.get("", response_model=list[EncadreurNotificationResponse])
async def get_encadreur_notifications(
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Récupère la liste des notifications destinées à l'encadreur connecté,
    avec toutes les précisions sur les adolescents en attente de validation.
    """
    enc_id = current_user.get("sub")
    role = current_user.get("role")

    if role == "ADMIN":
        stmt = (
            select(EncadreurNotification)
            .order_by(EncadreurNotification.created_at.desc())
            .limit(100)
        )

        result = await db.execute(stmt)
        notifs = result.scalars().all()
    else:
        stmt = (
            select(EncadreurNotification)
            .where(EncadreurNotification.encadreur_id == enc_id)
            .order_by(EncadreurNotification.created_at.desc())
        )
        result = await db.execute(stmt)
        notifs = result.scalars().all()

    result = []
    for n in notifs:
        ado_dict = None
        if n.adolescent_id:
            stmt = select(Adolescent).where(Adolescent.id == n.adolescent_id)
            result_ado = await db.execute(stmt)
            ado = result_ado.scalars().first()
            if ado:
                ado_dict = {
                    "id": ado.id,
                    "prenom": ado.prenom,
                    "age": ado.age,
                    "sexe": ado.sexe,
                    "province": ado.province,
                    "ville": ado.ville,
                    "milieu": ado.milieu,
                    "statut_scolaire": ado.statut_scolaire,
                    "handicap": ado.handicap,
                    "canal_inscription": ado.canal_inscription.value,
                    "telephone_parent": ado.telephone_parent,
                    "statut_inscription": ado.statut_inscription.value,
                }

        result.append(
            EncadreurNotificationResponse(
                id=n.id,
                encadreur_id=n.encadreur_id,
                adolescent_id=n.adolescent_id,
                type_notification=n.type_notification,
                titre=n.titre,
                message=n.message,
                is_read=n.is_read,
                created_at=n.created_at,
                adolescent_details=ado_dict,
            )
        )

    return result


@router.patch("/{notif_id}/read")
async def mark_notification_as_read(
    notif_id: str,
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    result_notif = await db.execute(
        select(EncadreurNotification).where(EncadreurNotification.id == notif_id)
    )

    notif = result_notif.scalars().first()
    if not notif:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Notification introuvable."
        )

    notif.is_read = True
    await db.commit()
    return {"message": "Notification marquée comme lue.", "id": notif_id}


@router.get("/unread-count")
async def get_unread_count(
    current_user: Annotated[dict, Depends(require_encadreur_or_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    enc_id = current_user.get("sub")
    role = current_user.get("role")

    # On prépare la requête de comptage
    stmt = select(func.count(EncadreurNotification.id)).where(
        EncadreurNotification.is_read.is_(False)
    )

    if role != "ADMIN":
        stmt = stmt.where(EncadreurNotification.encadreur_id == enc_id)

    # On exécute et on récupère le résultat
    result = await db.execute(stmt)
    count = result.scalar()

    # On retourne le résultat en gérant le cas où count est None
    return {"unread_count": count or 0}
