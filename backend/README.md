# 🇨🇩 UNICEF RDC - Backend FastAPI pour l'Engagement des Adolescents & Enfants Reporters

Backend asynchrone haute performance développé en **FastAPI**, **SQLAlchemy** et **Pydantic v2** pour soutenir les 7 modules du programme de coopération UNICEF RDC (CPD 2025–2029).

---

## 🔑 Identifiants d'Accès Pré-créés

### 1. Administrateur National UNICEF (Section C&A / T4D)
- **Email / Identifiant** : `admin@unicef.cd` (ou `ADM-UNICEF-01`)
- **Mot de passe** : `AdminUnicef2026!`
- **Rôle** : `ADMIN`
- **Périmètre** : Supervision globale nationale, validation finale Ponabana (Niveau 2), consultation de la base désagrégée, export CSV/DEVINFO, gestion des incidents de sauvegarde SLA 24h.

### 2. Encadreurs REIPE (Superviseurs de Clubs & Zones)
| Nom & Prénom | ID Encadreur | Email de Connexion | Mot de Passe | Club Assigné & Zone |
| :--- | :--- | :--- | :--- | :--- |
| **Alain Mukendi** | `ENC-KIN-01` | `alain.mukendi@reipe.cd` | `Encadreur2026!` | *Club Plaidoyer Nsele* (Kinshasa) |
| **Sarah Kasongo** | `ENC-LUB-01` | `sarah.k@reipe.cd` | `Encadreur2026!` | *Club Voix des Jeunes Katanga* (Lubumbashi) |
| **Jean Tshilumba** | `ENC-KAN-01` | `jean.t@reipe.cd` | `Encadreur2026!` | *Club Espoir & Climat Kananga* (Kasaï-Central) |

---

## 🚀 Démarrage Rapide

### 1. Installation des dépendances
```bash
pip install -r backend/requirements.txt
```

### 2. Lancement du serveur d'API
```bash
python backend/run.py
```
Le serveur démarre sur `http://127.0.0.1:8000`.

### 3. Documentation Interactive & Swagger
- **Swagger UI** : `http://127.0.0.1:8000/docs`
- **ReDoc** : `http://127.0.0.1:8000/redoc`

---

## 🧪 Méthodes de Test & Validation

### A. Exécuter la suite de tests automatisés (Pytest)
```bash
pytest backend/tests/test_api.py -v
```

### B. Tester le flux d'inscription et de validation Encadreur via cURL / Swagger

#### 1. Inscription d'un adolescent via le canal Web, USSD ou Chatbot
```bash
curl -X POST "http://127.0.0.1:8000/api/v1/registrations" \
  -H "Content-Type: application/json" \
  -d '{
    "prenom": "Ketsia",
    "age": 15,
    "sexe": "F",
    "province": "Kinshasa",
    "ville": "Nsele",
    "milieu": "Urbain",
    "statut_scolaire": "Scolarisé",
    "handicap": false,
    "langue_preferee": "Lingála",
    "telephone": "+243819998877",
    "telephone_parent": "+243819998800",
    "canal_inscription": "WEB"
  }'
```

#### 2. Connexion de l'Encadreur et consultation des notifications avec détails
```bash
# Obtenir le Token JWT
curl -X POST "http://127.0.0.1:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "identifiant_ou_email": "alain.mukendi@reipe.cd",
    "mot_de_passe_ou_otp": "Encadreur2026!",
    "role": "ENCADREUR"
  }'

# Consulter les notifications de la zone
curl -X GET "http://127.0.0.1:8000/api/v1/notifications" \
  -H "Authorization: Bearer <TOKEN_OBTENU>"
```

#### 3. Validation de l'inscription par l'Encadreur
```bash
curl -X POST "http://127.0.0.1:8000/api/v1/registrations/<ID_ADOLESCENT>/validate" \
  -H "Authorization: Bearer <TOKEN_OBTENU>" \
  -H "Content-Type: application/json" \
  -d '{
    "statut": "CONFIRMED",
    "commentaire_encadreur": "Dossier vérifié et confirmé dans le Club Plaidoyer Nsele"
  }'
```

#### 4. Consultation du rapport désagrégé complet
```bash
curl -X GET "http://127.0.0.1:8000/api/v1/reports/disaggregated"
```

---

## 🌐 Intégration avec l'Écosystème UNICEF existant

1. **RapidPro / U-Report (`/api/v1/rapidpro/webhook`)** :
   - Webhook récepteur pour enregistrer automatiquement les adolescents ayant répondu au bot WhatsApp ou SMS U-Report.
   - Routage automatique d'une notification vers l'encadreur du club local.

2. **Passerelles Télécoms GSM USSD (`/api/v1/rapidpro/simulate-ussd`)** :
   - Compatible avec les sessions de code court `*120*243#` des 4 opérateurs (Vodacom, Airtel, Orange, Africell).

3. **WordPress Ponabana (`/api/v1/ponabana/reportages/{id}/publish-n2`)** :
   - Circuit de modération à double niveau : l'Encadreur donne son avis N1, puis le Comité Ponabana / UNICEF approuve et déclenche la publication via l'API REST WordPress (`/wp-json/wp/v2/posts`).

4. **KoboToolbox & DEVINFO / RAM UNICEF (`/api/v1/reports/export-csv`)** :
   - Export CSV conforme aux structures d'indicateurs désagrégés (sexe, milieu, handicap, canal, province).
