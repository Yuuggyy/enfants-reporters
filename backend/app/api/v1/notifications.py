from typing import List, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.models.models import EncadreurNotification, Adolescent
from backend.app.schemas.schemas import EncadreurNotificationResponse
from backend.app.api.v1.auth import get_current_user_payload, require_encadreur_or_admin

router = APIRouter(prefix="/notifications", tags=["Notifications Encadreur"])

@router.get("", response_model=List[EncadreurNotificationResponse])
def get_encadreur_notifications(
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    """
    Récupère la liste des notifications destinées à l'encadreur connecté,
    avec toutes les précisions sur les adolescents en attente de validation.
    """
    enc_id = current_user.get("sub")
    role = current_user.get("role")

    if role == "ADMIN":
        notifs = db.query(EncadreurNotification).order_by(EncadreurNotification.created_at.desc()).limit(100).all()
    else:
        notifs = db.query(EncadreurNotification).filter(
            EncadreurNotification.encadreur_id == enc_id
        ).order_by(EncadreurNotification.created_at.desc()).all()

    result = []
    for n in notifs:
        ado_dict = None
        if n.adolescent_id:
            ado = db.query(Adolescent).filter(Adolescent.id == n.adolescent_id).first()
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
                    "statut_inscription": ado.statut_inscription.value
                }
        
        result.append(EncadreurNotificationResponse(
            id=n.id,
            encadreur_id=n.encadreur_id,
            adolescent_id=n.adolescent_id,
            type_notification=n.type_notification,
            titre=n.titre,
            message=n.message,
            is_read=n.is_read,
            created_at=n.created_at,
            adolescent_details=ado_dict
        ))

    return result

@router.put("/{notif_id}/read")
def mark_notification_as_read(
    notif_id: str,
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    notif = db.query(EncadreurNotification).filter(EncadreurNotification.id == notif_id).first()
    if not notif:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Notification introuvable.")

    notif.is_read = True
    db.commit()
    return {"message": "Notification marquée comme lue.", "id": notif_id}

@router.get("/unread-count")
def get_unread_count(
    current_user: dict = Depends(require_encadreur_or_admin),
    db: Session = Depends(get_db)
):
    enc_id = current_user.get("sub")
    role = current_user.get("role")

    query = db.query(EncadreurNotification).filter(EncadreurNotification.is_read == False)
    if role != "ADMIN":
        query = query.filter(EncadreurNotification.encadreur_id == enc_id)

    count = query.count()
    return {"unread_count": count}
