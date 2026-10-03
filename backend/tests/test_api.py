import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from backend.app.main import app
from backend.app.db.session import Base, get_db
from backend.app.db.init_db import init_db

# Base de données de test en mémoire isolée
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="session", autouse=True)
def setup_test_db():
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    init_db(db)
    db.close()
    yield
    Base.metadata.drop_all(bind=engine)

def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_admin_precreated_login():
    """Vérifie la connexion avec les identifiants pré-créés de l'Administrateur National UNICEF"""
    response = client.post("/api/v1/auth/login", json={
        "identifiant_ou_email": "admin@unicef.cd",
        "mot_de_passe_ou_otp": "AdminUnicef2026!",
        "role": "ADMIN"
    })
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["role"] == "ADMIN"
    assert data["user_id"] == "ADM-UNICEF-01"

def test_encadreur_precreated_login():
    """Vérifie la connexion de l'Encadreur REIPE Nsele"""
    response = client.post("/api/v1/auth/login", json={
        "identifiant_ou_email": "alain.mukendi@reipe.cd",
        "mot_de_passe_ou_otp": "Encadreur2026!",
        "role": "ENCADREUR"
    })
    assert response.status_code == 200
    data = response.json()
    assert data["role"] == "ENCADREUR"
    assert data["user_id"] == "ENC-KIN-01"

def test_multichannel_registration_and_encadreur_notification():
    """
    Teste l'inscription multicanale (Web, USSD, RapidPro, Assistée)
    et vérifie que l'encadreur reçoit des notifications précises avec toutes les métadonnées.
    """
    # 1. Inscription Web
    reg_payload = {
        "prenom": "Ketsia",
        "age": 15,
        "sexe": "F",
        "province": "Kinshasa",
        "ville": "Nsele",
        "milieu": "Urbain",
        "statut_scolaire": "Scolarisé",
        "handicap": False,
        "langue_preferee": "Lingála",
        "telephone": "+243819998877",
        "telephone_parent": "+243819998800",
        "canal_inscription": "WEB"
    }
    res_reg = client.post("/api/v1/registrations", json=reg_payload)
    assert res_reg.status_code == 201
    ado_data = res_reg.json()
    assert ado_data["statut_inscription"] == "PENDING_ENCADREUR_VALIDATION"
    ado_id = ado_data["id"]

    # 2. Connexion Encadreur
    login_enc = client.post("/api/v1/auth/login", json={
        "identifiant_ou_email": "alain.mukendi@reipe.cd",
        "mot_de_passe_ou_otp": "Encadreur2026!",
        "role": "ENCADREUR"
    }).json()
    headers_enc = {"Authorization": f"Bearer {login_enc['access_token']}"}

    # 3. Vérification des notifications reçues par l'encadreur
    res_notifs = client.get("/api/v1/notifications", headers=headers_enc)
    assert res_notifs.status_code == 200
    notifs = res_notifs.json()
    assert len(notifs) > 0
    # Vérifier que la notification contient les détails précis de l'enfant
    matching_notif = next((n for n in notifs if n["adolescent_id"] == ado_id), None)
    assert matching_notif is not None
    assert "Ketsia" in matching_notif["titre"]
    assert matching_notif["adolescent_details"]["sexe"] == "F"
    assert matching_notif["adolescent_details"]["canal_inscription"] == "WEB"

    # 4. Validation / Confirmation de l'inscription par l'encadreur
    res_val = client.post(
        f"/api/v1/registrations/{ado_id}/validate",
        json={"statut": "CONFIRMED", "commentaire_encadreur": "Dossier vérifié et validé"},
        headers=headers_enc
    )
    assert res_val.status_code == 200
    assert res_val.json()["statut_inscription"] == "CONFIRMED"

def test_ussd_simulation_flow():
    """Teste la simulation du parcours GSM USSD"""
    res = client.post("/api/v1/rapidpro/simulate-ussd", json={
        "session_id": "USSD-SESS-99",
        "phone_number": "+243891234567",
        "ussd_string": "*120*243*1*Merveille*16*F*Kinshasa*Nsele*0810009999#"
    })
    assert res.status_code == 200
    data = res.json()
    assert "Inscription réussie" in data["ussd_response"]
    assert "ADO-2026-" in data["adolescent_id"]

def test_disaggregated_reports():
    """
    Vérifie la désagrégation exhaustive du rapportage :
    - Sexe (Parité filles/garçons)
    - Origines / Canaux (USSD, Chatbot RapidPro, Web, SMS, Assisté)
    - Zones / Provinces
    - Milieu (Urbain/Rural)
    """
    # Enregistrer des ados via différents canaux pour tester la désagrégation
    channels = [
        {"prenom": "ChatbotAdo", "sexe": "M", "canal_inscription": "CHATBOT_RAPIDPRO", "province": "Kinshasa", "milieu": "Urbain"},
        {"prenom": "SmsAdo", "sexe": "F", "canal_inscription": "SMS", "province": "Haut-Katanga", "milieu": "Rural"},
        {"prenom": "AssistedAdo", "sexe": "M", "canal_inscription": "ASSISTED_REIPE", "province": "Kasaï-Central", "milieu": "Rural"},
    ]
    for c in channels:
        client.post("/api/v1/registrations", json={
            "prenom": c["prenom"],
            "age": 15,
            "sexe": c["sexe"],
            "province": c["province"],
            "ville": "Centre",
            "milieu": c["milieu"],
            "statut_scolaire": "Scolarisé",
            "handicap": False,
            "langue_preferee": "Français",
            "telephone": f"+2438900000{c['sexe']}",
            "telephone_parent": "+243890000099",
            "canal_inscription": c["canal_inscription"]
        })

    res = client.get("/api/v1/reports/disaggregated")
    assert res.status_code == 200
    report = res.json()

    assert report["total_inscriptions"] > 0
    assert "F" in report["repartition_sexe"]
    assert "M" in report["repartition_sexe"]
    assert "USSD" in report["repartition_canaux"]
    assert "CHATBOT_RAPIDPRO" in report["repartition_canaux"]
    assert "WEB" in report["repartition_canaux"]
    assert "SMS" in report["repartition_canaux"]
    assert "ASSISTED_REIPE" in report["repartition_canaux"]
    assert "Kinshasa" in report["repartition_provinces"]
    assert "Urbain" in report["repartition_milieu"]

def test_csv_export():
    res = client.get("/api/v1/reports/export-csv")
    assert res.status_code == 200
    assert "text/csv" in res.headers["content-type"]
    assert "ID_Adolescent,Prenom,Age,Sexe" in res.text

def test_safeguard_24h_reporting():
    """Vérifie le signalement sauvegarde 24/7"""
    res = client.post("/api/v1/safeguard/report", json={
        "type_incident": "Harcèlement en ligne",
        "gravite": "URGENT",
        "description": "Signalement d'intimidation dans un groupe d'élèves.",
        "province": "Kinshasa"
    })
    assert res.status_code == 201
    assert res.json()["statut"] == "SIGNALÉ_SLA_24H"
