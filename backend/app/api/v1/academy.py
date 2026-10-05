from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ...db.session import get_db
from ...models.models import Adolescent, AuditLog
from .auth import get_current_user_payload

router = APIRouter(prefix="/academy", tags=["Académie, Formations & Certification"])

MODULES_DATA = [
    {
        "id": "MOD-01",
        "titre": "Module 1 : Droits Fondamentaux de l'Enfant",
        "duree": "12 minutes",
        "description": "Comprendre la CDE, les droits à la protection, l'éducation, et la participation active.",
        "quiz": [
            {
                "question": "Quel est le principe fondamental garantissant à chaque enfant d'exprimer son opinion ?",
                "options": [
                    "Le droit à la participation",
                    "L'obligation de silence",
                    "Le droit au jeu uniquement",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
    {
        "id": "MOD-02",
        "titre": "Module 2 : Tactiques de Plaidoyer & Mobilisation",
        "duree": "15 minutes",
        "description": "Apprendre à formuler des demandes d'impact auprès des décideurs communautaires.",
        "quiz": [
            {
                "question": "Quelle est la première étape d'une action de plaidoyer efficace ?",
                "options": [
                    "Identifier le problème précis et la cible",
                    "Faire une manifestation sans autorisation",
                    "Attendre l'accord sans dossier",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
    {
        "id": "MOD-03",
        "titre": "Module 3 : Journalisme Citoyen & Narration Mobile",
        "duree": "10 minutes",
        "description": "Techniques de reportage par smartphone, cadrage photo et interview respectueuse.",
        "quiz": [
            {
                "question": "Quelle règle est indispensable avant de photographier un mineur pour un reportage ?",
                "options": [
                    "Recueillir le consentement éclairé parental et de l'enfant",
                    "Prendre la photo discrètement",
                    "Partager d'abord sur les réseaux",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
    {
        "id": "MOD-04",
        "titre": "Module 4 : Vérification des Faits (Fact-Checking)",
        "duree": "14 minutes",
        "description": "Lutter contre les infox et rumeurs nocives en milieu scolaire et communautaire.",
        "quiz": [
            {
                "question": "Comment vérifier la véracité d'une information virale sur WhatsApp ?",
                "options": [
                    "Croiser les sources avec des médias fiables ou déclarations officielles",
                    "La renvoyer à tous ses contacts",
                    "Croire tout message avec beaucoup de partages",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
    {
        "id": "MOD-05",
        "titre": "Module 5 : Sécurité Numérique & Protection en Ligne",
        "duree": "11 minutes",
        "description": "Protéger ses données personnelles, mots de passe et éviter le cyberharcèlement.",
        "quiz": [
            {
                "question": "Que faire en cas de message menaçant ou suspect en ligne ?",
                "options": [
                    "Alerter un encadreur/parent et utiliser le bouton de sauvegarde",
                    "Répondre avec agressivité",
                    "Supprimer l'application sans en parler",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
    {
        "id": "MOD-06",
        "titre": "Module 6 : Éthique & Ligne Éditoriale Ponabana",
        "duree": "13 minutes",
        "description": "La charte éthique des Enfants Reporters et la valorisation des solutions positives.",
        "quiz": [
            {
                "question": "Quel est l'objectif principal des reportages Ponabana ?",
                "options": [
                    "Donner une voix constructive aux enfants et proposer des solutions",
                    "Créer du sensationnalisme",
                    "Faire la publicité d'entreprises",
                ],
                "reponse_correcte": 0,
            }
        ],
    },
]


class QuizSubmissionRequest(BaseModel):
    module_id: str
    reponses: list[int]


@router.get("/modules")
async def get_modules():
    return MODULES_DATA


@router.post("/submit-quiz")
async def submit_quiz(
    data: QuizSubmissionRequest,
    current_user: Annotated[dict, Depends(get_current_user_payload)],
    db: Annotated[AsyncSession, Depends(get_db)],
):
    user_id = current_user.get("sub")
    result = await db.execute(
        select(Adolescent).where(Adolescent.id == user_id).limit(1)
    )
    ado = result.scalars().first()

    if not ado:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Adolescent introuvable."
        )

    # Validation du score
    mod = next((m for m in MODULES_DATA if m["id"] == data.module_id), None)
    if not mod:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Module introuvable."
        )

    reussite = True
    for i, q in enumerate(mod["quiz"]):
        if i >= len(data.reponses) or data.reponses[i] != q["reponse_correcte"]:
            reussite = False
            break

    if reussite:
        ado.points_xp = (ado.points_xp or 0) + 100
        # Si c'est le module 6, débloquer la certification
        if data.module_id == "MOD-06" and not ado.certifie:
            ado.certifie = True
            ado.code_certificat = f"UNICEF-RDC-CERT-{datetime.now().year}-{ado.province[:3].upper()}-{ado.id[-4:]}"

        db.add(
            AuditLog(
                user_id=ado.id,
                user_role="ADOLESCENT",
                action="QUIZ_REUSSI",
                details=f"Réussite du {mod['titre']} (+100 XP). Certifié: {ado.certifie}",
            )
        )
        await db.commit()

        return {
            "success": True,
            "message": "Félicitations ! Module validé avec succès.",
            "points_gagnes": 100,
            "total_xp": ado.points_xp,
            "certifie": ado.certifie,
            "code_certificat": ado.code_certificat,
        }
    else:
        return {
            "success": False,
            "message": "Score insuffisant. Révisez la capsule et tentez à nouveau le quiz.",
            "points_gagnes": 0,
        }
