from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from . import models
from .api.v1 import (
    academy,
    auth,
    notifications,
    ponabana,
    rapidpro,
    registrations,
    reports,
    safeguard,
    ussd,
)
from .core.config import settings
from .db.init_db import init_db
from .db.session import Base, engine


@asynccontextmanager
async def lifespan(app: FastAPI):
    # On ouvre une connexion au moteur pour créer les tables si elles n'existent pas.
    print("📋 Tables connues :", list(Base.metadata.tables.keys()))
    async with engine.begin() as conn:
        # run_sync permet d'exécuter une fonction synchrone (create_all) dans un contexte async.
        await conn.run_sync(Base.metadata.create_all)

    await init_db()
    # Le 'yield' sépare le code de démarrage du code d'arrêt.
    # L'application tourne pendant que le code est suspendu ici.
    yield

    # --- Code exécuté À L'ARRÊT de l'application ---
    # On ferme proprement le moteur de base de données pour libérer les ressources.
    await engine.dispose()


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="API Centrale FastAPI pour l'écosystème d'engagement des adolescents et enfants reporters en RDC (UNICEF CPD 2025-2029).",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

# Configuration CORS pour Flutter App & Web PWA
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusion des Routers API v1
api_v1_prefix = settings.API_V1_STR
app.include_router(auth.router, prefix=api_v1_prefix)
app.include_router(registrations.router, prefix=api_v1_prefix)
app.include_router(notifications.router, prefix=api_v1_prefix)
app.include_router(reports.router, prefix=api_v1_prefix)
app.include_router(rapidpro.router, prefix=api_v1_prefix)
app.include_router(ponabana.router, prefix=api_v1_prefix)
app.include_router(safeguard.router, prefix=api_v1_prefix)
app.include_router(academy.router, prefix=api_v1_prefix)
app.include_router(ussd.router, prefix=api_v1_prefix)


@app.get("/", tags=["Santé"])
def root():
    return {
        "projet": settings.PROJECT_NAME,
        "statut": "Opérationnel",
        "documentation": "/docs",
        "api_v1": api_v1_prefix,
    }


@app.get("/health", tags=["Santé"])
def health_check():
    return {"status": "healthy", "service": "unicef-ados-backend-fastapi"}
