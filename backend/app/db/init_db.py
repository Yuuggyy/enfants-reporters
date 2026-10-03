from datetime import datetime
from sqlalchemy.orm import Session
from backend.app.models.models import (
    Base, AdminUser, Encadreur, Club, Adolescent, EncadreurNotification, Reportage, IncidentSauvegarde,
    CanalInscriptionEnum, StatutInscriptionEnum, StatutConsentementEnum, StatutReportageEnum
)
from backend.app.core.security import get_password_hash
from backend.app.db.session import engine

def init_db(db: Session) -> None:
    # Créer les tables si elles n'existent pas
    Base.metadata.create_all(bind=engine)

    # 1. Précréation de l'Administrateur National UNICEF
    admin = db.query(AdminUser).filter(AdminUser.email == "admin@unicef.cd").first()
    if not admin:
        admin = AdminUser(
            id="ADM-UNICEF-01",
            email="admin@unicef.cd",
            hashed_password=get_password_hash("AdminUnicef2026!"),
            prenom="Superviseur",
            nom="UNICEF National",
            section="UNICEF C&A (Communication & Plaidoyer / T4D)",
            role_titre="Administrateur National",
            is_active=True
        )
        db.add(admin)

    # 2. Précréation des Encadreurs REIPE (Superviseurs de Club)
    encadreurs_data = [
        {
            "id": "ENC-KIN-01",
            "email": "alain.mukendi@reipe.cd",
            "password": "Encadreur2026!",
            "prenom": "Alain",
            "nom": "Mukendi",
            "telephone": "+243810011223",
            "organisation": "REIPE Kinshasa",
            "province": "Kinshasa",
            "ville": "Nsele",
            "territoire": "Nsele"
        },
        {
            "id": "ENC-LUB-01",
            "email": "sarah.k@reipe.cd",
            "password": "Encadreur2026!",
            "prenom": "Sarah",
            "nom": "Kasongo",
            "telephone": "+243820033445",
            "organisation": "REIPE Haut-Katanga",
            "province": "Haut-Katanga",
            "ville": "Lubumbashi",
            "territoire": "Lubumbashi"
        },
        {
            "id": "ENC-KAN-01",
            "email": "jean.t@reipe.cd",
            "password": "Encadreur2026!",
            "prenom": "Jean",
            "nom": "Tshilumba",
            "telephone": "+243890055667",
            "organisation": "REIPE Kasaï-Central",
            "province": "Kasaï-Central",
            "ville": "Kananga",
            "territoire": "Kananga"
        }
    ]

    for enc_data in encadreurs_data:
        enc = db.query(Encadreur).filter(Encadreur.id == enc_data["id"]).first()
        if not enc:
            enc = Encadreur(
                id=enc_data["id"],
                email=enc_data["email"],
                hashed_password=get_password_hash(enc_data["password"]),
                prenom=enc_data["prenom"],
                nom=enc_data["nom"],
                telephone=enc_data["telephone"],
                organisation=enc_data["organisation"],
                province=enc_data["province"],
                ville=enc_data["ville"],
                territoire=enc_data["territoire"],
                is_active=True
            )
            db.add(enc)

    db.flush()

    # 3. Précréation des Clubs d'engagement
    clubs_data = [
        {"id": "CLUB-KIN-01", "nom": "Club Plaidoyer Nsele", "province": "Kinshasa", "ville": "Nsele", "encadreur_id": "ENC-KIN-01"},
        {"id": "CLUB-LUB-01", "nom": "Club Voix des Jeunes Katanga", "province": "Haut-Katanga", "ville": "Lubumbashi", "encadreur_id": "ENC-LUB-01"},
        {"id": "CLUB-KAN-01", "nom": "Club Espoir & Climat Kananga", "province": "Kasaï-Central", "ville": "Kananga", "encadreur_id": "ENC-KAN-01"},
        {"id": "CLUB-GOM-01", "nom": "Club Reporters de la Paix Goma", "province": "Nord-Kivu", "ville": "Goma", "encadreur_id": "ENC-KIN-01"},
    ]

    for c_data in clubs_data:
        c = db.query(Club).filter(Club.id == c_data["id"]).first()
        if not c:
            c = Club(
                id=c_data["id"],
                nom=c_data["nom"],
                province=c_data["province"],
                ville=c_data["ville"],
                encadreur_id=c_data["encadreur_id"]
            )
            db.add(c)

    db.flush()

    # Structure prête sans données d'adolescents mockées
    db.commit()
