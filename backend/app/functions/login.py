from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from ..core.security import create_access_token, verify_password
from ..models.models import Admin, Adolescent, AuditLog, Encadreur, RoleEnum
from ..schemas.schemas import TokenResponse

# =========================================================================
# FONCTIONS PRIVÉES D'AUTHENTIFICATION (Extraites pour réduire la complexité)
# =========================================================================


async def _login_admin(
    db: AsyncSession, identifiant: str, secret: str
) -> TokenResponse:
    result = await db.execute(
        select(Admin).where((Admin.email == identifiant)).limit(1)
    )

    admin = result.scalars().first()

    if not admin or not verify_password(secret, str(admin.hashed_password)):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Identifiant Administrateur ou mot de passe incorrect.",
        )

    token = create_access_token(
        subject=str(admin.id),
        role=RoleEnum.ADMIN.value,
        extra_claims={"section": admin.section, "email": admin.email},
    )

    db.add(
        AuditLog(
            user_id=admin.id,
            user_role="ADMIN",
            action="LOGIN",
            details=f"Connexion réussie Admin {admin.email}",
        )
    )
    await db.commit()

    return TokenResponse(
        access_token=token,
        user_id=admin.id,
        role=RoleEnum.ADMIN.value,
        prenom=admin.prenom,
        nom_ou_pseudo=admin.nom,
        organisation_ou_club=admin.section,
        province="National",
    )


async def _login_encadreur(
    db: AsyncSession, identifiant: str, secret: str
) -> TokenResponse:
    result = await db.execute(
        select(Encadreur).where((Encadreur.email == identifiant)).limit(1)
    )
    enc = result.scalars().first()
    if not enc or not verify_password(secret, str(enc.hashed_password)):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Identifiant Encadreur ou mot de passe incorrect.",
        )

    token = create_access_token(
        subject=str(enc.id),
        role=RoleEnum.ENCADREUR.value,
        extra_claims={
            "province": enc.province,
            "ville": enc.ville,
            "email": enc.email,
        },
    )

    db.add(
        AuditLog(
            user_id=enc.id,
            user_role="ENCADREUR",
            action="LOGIN",
            details=f"Connexion réussie Encadreur {enc.nom} {enc.prenom}",
        )
    )
    await db.commit()

    club_nom = enc.clubs[0].nom if enc.clubs else enc.organisation
    return TokenResponse(
        access_token=token,
        user_id=str(enc.id),
        role=RoleEnum.ENCADREUR.value,
        prenom=str(enc.prenom),
        nom_ou_pseudo=str(enc.nom),
        organisation_ou_club=str(club_nom),
        province=str(enc.province),
    )


async def _login_adolescent(db: AsyncSession, identifiant: str) -> TokenResponse:
    result = await db.execute(
        select(Adolescent)
        .options(selectinload(Adolescent.club))  # ⬅️ AJOUTE ÇA
        .where(Adolescent.telephone == identifiant)
    )
    ado = result.scalar_one_or_none()
    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Dossier adolescent introuvable avec cet identifiant ou numéro de téléphone.",
        )

    # Pour les ados : validation d'OTP (pour démo, tout code à 4-6 chiffres ou match exact)
    token = create_access_token(
        subject=str(ado.id),
        role=RoleEnum.ADOLESCENT.value,
        extra_claims={"club_id": ado.club_id, "province": ado.province},
    )

    club_nom = ado.club.nom if ado.club else "Club Jeunes"
    return TokenResponse(
        access_token=token,
        user_id=str(ado.id),
        role=RoleEnum.ADOLESCENT.value,
        prenom=str(ado.prenom),
        nom_ou_pseudo=f"@{ado.prenom.lower()}_{ado.ville.lower()}",
        organisation_ou_club=club_nom,
        province=str(ado.province),
    )
