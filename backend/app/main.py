from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.core.config import settings
from backend.app.db.session import SessionLocal
from backend.app.db.init_db import init_db
from backend.app.api.v1 import (
    auth, registrations, notifications, reports, rapidpro, ponabana, safeguard, academy
)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Initialisation et pré-population de la base (Super Admin, Encadreurs, Clubs)
    db = SessionLocal()
    try:
        init_db(db)
        print("[OK] Base de donnees initialisee : Administrateur UNICEF & Encadreurs pre-crees.")
    finally:
        db.close()
    yield

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="API Centrale FastAPI pour l'écosystème d'engagement des adolescents et enfants reporters en RDC (UNICEF CPD 2025-2029).",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc"
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

@app.get("/", tags=["Santé"])
def root():
    return {
        "projet": settings.PROJECT_NAME,
        "statut": "Opérationnel",
        "documentation": "/docs",
        "api_v1": api_v1_prefix
    }

@app.get("/health", tags=["Santé"])
def health_check():
    return {"status": "healthy", "service": "unicef-ados-backend-fastapi"}
