from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field

from ..models.models import (
    CanalInscriptionEnum,
    StatutConsentementEnum,
    StatutInscriptionEnum,
    StatutReportageEnum,
)


# --- AUTH SCHEMAS ---
class LoginRequest(BaseModel):
    email_or_identifiant: str = Field(
        ..., description="Email pour Admin/Encadreur ou ID/Téléphone pour Adolescent"
    )
    mot_de_passe: str = Field(..., description="Mot de passe ou Code OTP")
    role: str = Field(default="ADOLESCENT", description="ADMIN, ENCADREUR, ADOLESCENT")


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    role: str
    prenom: str
    nom_ou_pseudo: str
    organisation_ou_club: str | None
    province: str | None

    model_config = ConfigDict(from_attributes=True)


# --- INSCRIPTION SCHEMAS ---
class AdolescentRegistrationCreate(BaseModel):
    prenom: str = Field(..., min_length=2, max_length=100)
    age: int = Field(..., ge=12, le=17, description="Âge strict entre 12 et 17 ans")
    sexe: str = Field(
        ..., pattern="^(F|M)$", description="'F' pour Fille ou 'M' pour Garçon"
    )
    province: str = Field(
        ...,
        description="Ex: Kinshasa, Haut-Katanga, Nord-Kivu, Kasaï-Central, Kongo-Central",
    )
    ville: str = Field(..., description="Ex: Nsele, Lubumbashi, Goma, Kananga, Matadi")
    territoire: str | None
    milieu: str = Field(default="Urbain", pattern="^(Urbain|Rural|Péri-urbain)$")
    statut_scolaire: str = Field(
        default="Scolarisé",
        description="Scolarisé, Non scolarisé, Apprentissage/Métier",
    )
    handicap: bool = Field(default=False)
    description_handicap: str | None
    langue_preferee: str = Field(
        default="Français",
        description="Français, Lingála, Kiswahili, Tshiluba, Kikongo",
    )
    telephone: str = Field(..., description="Numéro de l'adolescent ou du parent")
    telephone_parent: str = Field(
        ..., description="Numéro WhatsApp/SMS du parent pour consentement"
    )
    canal_inscription: CanalInscriptionEnum = Field(default=CanalInscriptionEnum.WEB)


class ValidationInscriptionRequest(BaseModel):
    statut: StatutInscriptionEnum = Field(..., description="CONFIRMED ou REJECTED")
    commentaire_encadreur: str | None = Field(
        None, description="Note ou motif pour l'adolescent / club"
    )


class AdolescentResponse(BaseModel):
    id: str
    prenom: str
    age: int
    sexe: str
    province: str
    ville: str
    territoire: str | None
    milieu: str
    statut_scolaire: str
    handicap: bool
    description_handicap: str | None
    langue_preferee: str
    telephone: str
    telephone_parent: str
    club_id: str | None
    canal_inscription: CanalInscriptionEnum
    statut_inscription: StatutInscriptionEnum
    statut_consentement: StatutConsentementEnum
    mode_consentement: str
    points_xp: int
    certifie: bool
    code_certificat: str | None
    date_inscription: datetime
    date_validation_encadreur: datetime | None

    model_config = ConfigDict(from_attributes=True)


# --- NOTIFICATIONS SCHEMAS ---
class EncadreurNotificationResponse(BaseModel):
    id: str
    encadreur_id: str
    adolescent_id: str | None
    type_notification: str
    titre: str
    message: str
    is_read: bool
    created_at: datetime
    adolescent_details: dict[str, Any] | None

    model_config = ConfigDict(from_attributes=True)


# --- RAPPORTAGE DÉSAGRÉGÉ SCHEMAS ---
class DisaggregatedReportResponse(BaseModel):
    total_inscriptions: int
    total_confirmes: int
    total_en_attente_validation: int
    total_rejetes: int
    total_certifies: int

    # Indicateurs d'Équité & Parité
    repartition_sexe: dict[str, int]
    pourcentage_filles: float
    alerte_parite_50_50: bool

    # Origine / Canal d'inscription
    repartition_canaux: dict[str, int]

    # Géographie & Milieu
    repartition_provinces: dict[str, int]
    repartition_milieu: dict[str, int]
    pourcentage_rural: float

    # Vulnérabilités & Inclusivité
    repartition_statut_scolaire: dict[str, int]
    repartition_handicap: dict[str, int]
    repartition_langues: dict[str, int]


# --- REPORTAGE & PONABANA SCHEMAS ---
class ReportageCreate(BaseModel):
    titre: str = Field(..., min_length=5, max_length=250)
    contenu: str = Field(..., min_length=20)
    type_media: str = Field(
        default="article", description="article, photo, audio, video"
    )
    media_url: str | None
    theme: str = Field(default="Droits de l'enfant")
    exif_purge: bool = True
    floutage_actif: bool = True
    consentement_interviewes: bool = True


class ReportageResponse(BaseModel):
    id: str
    auteur_id: str
    titre: str
    contenu: str
    type_media: str
    media_url: str | None
    theme: str
    statut: StatutReportageEnum
    avis_encadreur: str | None
    relecture_ponabana: str | None
    exif_purge: bool
    floutage_actif: bool
    consentement_interviewes: bool
    date_soumission: datetime
    date_publication: datetime | None
    wordpress_post_id: int | None

    model_config = ConfigDict(from_attributes=True)


# --- SAUVEGARDE PSE SCHEMAS ---
class IncidentSauvegardeCreate(BaseModel):
    signaleur_type: str = "Adolescent"
    signaleur_contact: str | None
    type_incident: str
    gravite: str = "URGENT"
    description: str
    province: str


class IncidentSauvegardeResponse(BaseModel):
    id: str
    type_incident: str
    gravite: str
    description: str
    province: str
    statut: str
    date_signalement: datetime
    point_focal_assigne: str

    model_config = ConfigDict(from_attributes=True)


# --- CLUBS & ENCADREURS SCHEMAS ---
class ClubResponse(BaseModel):
    id: str
    nom: str
    province: str
    ville: str
    territoire: str | None
    encadreur_id: str | None
    theme: str | None = "Plaidoyer & Droits de l'Enfant"

    model_config = ConfigDict(from_attributes=True)


class EncadreurResponse(BaseModel):
    id: str
    email: str
    prenom: str
    nom: str
    telephone: str
    organisation: str
    province: str
    ville: str
    territoire: str | None
    is_active: bool

    model_config = ConfigDict(from_attributes=True)
