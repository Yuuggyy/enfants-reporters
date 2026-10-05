# app/schemas/ussd.py
from enum import Enum
from typing import Optional

from pydantic import BaseModel


class USSDRequest(BaseModel):
    """Payload envoyé par la passerelle USSD de l'opérateur (ex: Africa's Talking, Orange, Vodacom)."""

    sessionId: str
    phoneNumber: str
    text: str = ""  # "" au 1er hit, puis inputs concaténés par "*"
    serviceCode: Optional[str] = None
    networkCode: Optional[str] = None


class USSDResponse(BaseModel):
    """Réponse au format USSD : 'CON <message>' (continuer) ou 'END <message>' (terminer)."""

    message: str
    continueSession: bool = True


class USSDState(str, Enum):
    WELCOME = "WELCOME"
    ASK_PRENOM = "ASK_PRENOM"
    ASK_AGE = "ASK_AGE"
    ASK_SEXE = "ASK_SEXE"
    ASK_PROVINCE = "ASK_PROVINCE"
    ASK_VILLE = "ASK_VILLE"
    ASK_TERRITOIRE = "ASK_TERRITOIRE"
    ASK_MILIEU = "ASK_MILIEU"
    ASK_STATUT_SCOLAIRE = "ASK_STATUT_SCOLAIRE"
    ASK_HANDICAP = "ASK_HANDICAP"
    ASK_DESCRIPTION_HANDICAP = "ASK_DESCRIPTION_HANDICAP"
    ASK_LANGUE = "ASK_LANGUE"
    ASK_TELEPHONE = "ASK_TELEPHONE"
    ASK_TELEPHONE_PARENT = "ASK_TELEPHONE_PARENT"
    CONFIRM = "CONFIRM"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"
