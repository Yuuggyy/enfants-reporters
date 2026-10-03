import os
import sys

# Forcer l'encodage UTF-8 pour la console
os.environ["PYTHONIOENCODING"] = "utf-8"
os.environ["PYTHONUTF8"] = "1"

# Répertoire racine du projet
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

# Configurer PYTHONPATH pour les sous-processus reloader d'Uvicorn
existing_pythonpath = os.environ.get("PYTHONPATH", "")
os.environ["PYTHONPATH"] = (project_root + os.pathsep + existing_pythonpath) if existing_pythonpath else project_root

# Assurer que SQLAlchemy fonctionne sans bloquer sur les extensions C si nécessaire
os.environ["DISABLE_SQLALCHEMY_CEXT"] = "1"

import uvicorn

if __name__ == "__main__":
    print("=" * 60)
    print(" DEMARRAGE DU BACKEND FASTAPI - BANAPP UNICEF RDC")
    print("=" * 60)
    print(" -> Documentation Swagger interactive : http://127.0.0.1:8000/docs")
    print(" -> Documentation ReDoc               : http://127.0.0.1:8000/redoc")
    print(" -> Base de donnees locale            : unicef_ados.db (SQLite)")
    print("=" * 60)
    print(" COMPTES PRE-CONFIGURES POUR LES TESTS :")
    print(" 1. ADMIN NATIONAL UNICEF :")
    print("    - Email    : admin@unicef.cd")
    print("    - Password : AdminUnicef2026!")
    print(" 2. ENCADREUR REIPE (Kinshasa - Nsele) :")
    print("    - Email    : alain.mukendi@reipe.cd")
    print("    - Password : Encadreur2026!")
    print("=" * 60)
    
    uvicorn.run("backend.app.main:app", host="127.0.0.1", port=8000, reload=True, app_dir=project_root)
