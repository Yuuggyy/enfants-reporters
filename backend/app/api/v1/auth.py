from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ...core.security import decode_token, oauth2_scheme
from ...db.session import get_db
from ...functions.login import _login_admin, _login_adolescent, _login_encadreur
from ...models.models import Admin, Adolescent, AuditLog, Encadreur, RoleEnum
from ...schemas.schemas import LoginRequest, TokenResponse

router = APIRouter(prefix="/auth", tags=["Authentification"])


def get_current_user_payload(token: str = Depends(oauth2_scheme)) -> dict:
    return decode_token(token)


def require_admin(payload: Annotated[dict, Depends(get_current_user_payload)]):
    if payload.get("role") != RoleEnum.ADMIN.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé aux Administrateurs Nationaux UNICEF.",
        )
    return payload


def require_encadreur_or_admin(
    payload: Annotated[dict, Depends(get_current_user_payload)],
):
    if payload.get("role") not in [RoleEnum.ADMIN.value, RoleEnum.ENCADREUR.value]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé aux Encadreurs REIPE ou Administrateurs.",
        )
    return payload


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest, db: Annotated[AsyncSession, Depends(get_db)]):
    email_or_identifiant = request.email_or_identifiant.strip()
    secret = request.mot_de_passe.strip()

    # On exécute une requête SELECT filtrée par le username.
    result_admin = await db.execute(
        select(Admin).where(Admin.email == email_or_identifiant).limit(1)
    )
    result_encadreur = await db.execute(
        select(Encadreur).where(Encadreur.email == email_or_identifiant).limit(1)
    )

    result_ado = await db.execute(
        select(Adolescent).where(Adolescent.telephone == email_or_identifiant)
    )
    # 1. Redirection vers la fonction appropriée selon le rôle
    if result_admin.scalar_one_or_none():
        return await _login_admin(db, email_or_identifiant, secret)

    elif result_encadreur.scalar_one_or_none():
        return await _login_encadreur(db, email_or_identifiant, secret)

    elif result_ado.scalar_one_or_none():
        return await _login_adolescent(db, email_or_identifiant)
    else:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Identifiant ou mot de passe incorrect.",
        )


@router.get("/audit-logs")
async def get_audit_logs(
    current_user: Annotated[dict, Depends(require_admin)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    """
    Récupère le journal d'audit immuable des actions sensibles (Admin).
    """
    resulta_log = await db.execute(
        select(AuditLog).order_by(AuditLog.timestamp.desc()).limit(100)
    )
    logs = resulta_log.scalars().all()

    return [
        {
            "id": log.id,
            "user_id": log.user_id,
            "user_role": log.user_role,
            "action": log.action,
            "details": log.details,
            "ip_address": log.ip_address,
            "timestamp": log.timestamp.isoformat() if log.timestamp else "",
        }
        for log in logs
    ]
