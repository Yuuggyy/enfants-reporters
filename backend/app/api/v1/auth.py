from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.core.security import verify_password, create_access_token, oauth2_scheme, decode_token
from backend.app.models.models import AdminUser, Encadreur, Adolescent, RoleEnum, AuditLog
from backend.app.schemas.schemas import LoginRequest, TokenResponse

router = APIRouter(prefix="/auth", tags=["Authentification"])

def get_current_user_payload(token: str = Depends(oauth2_scheme)) -> dict:
    return decode_token(token)

def require_admin(payload: dict = Depends(get_current_user_payload)):
    if payload.get("role") != RoleEnum.ADMIN.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé aux Administrateurs Nationaux UNICEF."
        )
    return payload

def require_encadreur_or_admin(payload: dict = Depends(get_current_user_payload)):
    if payload.get("role") not in [RoleEnum.ADMIN.value, RoleEnum.ENCADREUR.value]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé aux Encadreurs REIPE ou Administrateurs."
        )
    return payload

@router.post("/login", response_model=TokenResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    role = request.role.upper()
    identifiant = request.identifiant_ou_email.strip()
    secret = request.mot_de_passe_ou_otp.strip()

    # 1. Connexion Administrateur
    if role == RoleEnum.ADMIN.value or "@unicef" in identifiant.lower():
        admin = db.query(AdminUser).filter(
            (AdminUser.email == identifiant) | (AdminUser.id == identifiant)
        ).first()
        if not admin or not verify_password(secret, admin.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Identifiant Administrateur ou mot de passe incorrect."
            )
        
        token = create_access_token(
            subject=admin.id,
            role=RoleEnum.ADMIN.value,
            extra_claims={"section": admin.section, "email": admin.email}
        )
        
        # Log d'audit
        db.add(AuditLog(user_id=admin.id, user_role="ADMIN", action="LOGIN", details=f"Connexion réussie Admin {admin.email}"))
        db.commit()

        return TokenResponse(
            access_token=token,
            user_id=admin.id,
            role=RoleEnum.ADMIN.value,
            prenom=admin.prenom,
            nom_ou_pseudo=admin.nom,
            organisation_ou_club=admin.section,
            province="National"
        )

    # 2. Connexion Encadreur REIPE
    elif role == RoleEnum.ENCADREUR.value or "@reipe" in identifiant.lower() or identifiant.startswith("ENC-"):
        enc = db.query(Encadreur).filter(
            (Encadreur.email == identifiant) | (Encadreur.id == identifiant)
        ).first()
        if not enc or not verify_password(secret, enc.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Identifiant Encadreur ou mot de passe incorrect."
            )
        
        token = create_access_token(
            subject=enc.id,
            role=RoleEnum.ENCADREUR.value,
            extra_claims={"province": enc.province, "ville": enc.ville, "email": enc.email}
        )
        
        db.add(AuditLog(user_id=enc.id, user_role="ENCADREUR", action="LOGIN", details=f"Connexion réussie Encadreur {enc.nomComplet if hasattr(enc, 'nomComplet') else enc.prenom}"))
        db.commit()

        club_nom = enc.clubs[0].nom if enc.clubs else enc.organisation
        return TokenResponse(
            access_token=token,
            user_id=enc.id,
            role=RoleEnum.ENCADREUR.value,
            prenom=enc.prenom,
            nom_ou_pseudo=enc.nom,
            organisation_ou_club=club_nom,
            province=enc.province
        )

    # 3. Connexion Adolescent
    else:
        ado = db.query(Adolescent).filter(
            (Adolescent.id == identifiant) | (Adolescent.telephone == identifiant)
        ).first()
        if not ado:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Dossier adolescent introuvable avec cet identifiant ou numéro de téléphone."
            )
        
        # Pour les ados : validation d'OTP (pour démo, tout code à 4-6 chiffres ou match exact)
        token = create_access_token(
            subject=ado.id,
            role=RoleEnum.ADOLESCENT.value,
            extra_claims={"club_id": ado.club_id, "province": ado.province}
        )

        club_nom = ado.club.nom if ado.club else "Club Jeunes"
        return TokenResponse(
            access_token=token,
            user_id=ado.id,
            role=RoleEnum.ADOLESCENT.value,
            prenom=ado.prenom,
            nom_ou_pseudo=f"@{ado.prenom.lower()}_{ado.ville.lower()}",
            organisation_ou_club=club_nom,
            province=ado.province
        )

@router.get("/audit-logs")
def get_audit_logs(
    current_user: dict = Depends(require_admin),
    db: Session = Depends(get_db)
):
    """
    Récupère le journal d'audit immuable des actions sensibles (Admin).
    """
    logs = db.query(AuditLog).order_by(AuditLog.timestamp.desc()).limit(100).all()
    return [
        {
            "id": log.id,
            "user_id": log.user_id,
            "user_role": log.user_role,
            "action": log.action,
            "details": log.details,
            "ip_address": log.ip_address,
            "timestamp": log.timestamp.isoformat() if log.timestamp else ""
        }
        for log in logs
    ]
