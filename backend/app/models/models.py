import enum
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from ..db.session import Base


class RoleEnum(str, enum.Enum):
    ADMIN = "ADMIN"
    ENCADREUR = "ENCADREUR"
    ADOLESCENT = "ADOLESCENT"
    COMITE_PONABANA = "COMITE_PONABANA"
    UNICEF_PSE = "UNICEF_PSE"


class CanalInscriptionEnum(str, enum.Enum):
    USSD = "USSD"
    CHATBOT_RAPIDPRO = "CHATBOT_RAPIDPRO"
    WEB = "WEB"
    SMS = "SMS"
    ASSISTED_REIPE = "ASSISTED_REIPE"


class StatutInscriptionEnum(str, enum.Enum):
    PENDING_ENCADREUR_VALIDATION = "PENDING_ENCADREUR_VALIDATION"
    CONFIRMED = "CONFIRMED"
    REJECTED = "REJECTED"


class StatutConsentementEnum(str, enum.Enum):
    EN_ATTENTE = "EN_ATTENTE"
    ACCORDE = "ACCORDE"
    REFUSE = "REFUSE"
    REVOQUE = "REVOQUE"


class StatutReportageEnum(str, enum.Enum):
    BROUILLON = "BROUILLON"
    SOUMIS_N1 = "SOUMIS_N1"  # En attente modération Encadreur
    VALIDE_N1 = "VALIDE_N1"  # Validé encadreur, en attente Ponabana
    PUBLIE_PONABANA_N2 = "PUBLIE_PONABANA_N2"  # Publié sur Ponabana WordPress
    A_CORRIGER = "A_CORRIGER"
    REJETE = "REJETE"


class Admin(Base):
    __tablename__ = "admin"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    email: Mapped[str] = mapped_column(
        String(120), unique=True, index=True, nullable=False
    )
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    prenom: Mapped[str] = mapped_column(String(100), nullable=False)
    nom: Mapped[str] = mapped_column(String(100), nullable=False)
    section: Mapped[str] = mapped_column(
        String(100), default="UNICEF C&A (Communication & Plaidoyer)"
    )
    role_titre: Mapped[str] = mapped_column(
        String(100), default="Administrateur National"
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)


class Encadreur(Base):
    __tablename__ = "encadreurs"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    email: Mapped[str] = mapped_column(
        String(120), unique=True, index=True, nullable=False
    )
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    prenom: Mapped[str] = mapped_column(String(100), nullable=False)
    nom: Mapped[str] = mapped_column(String(100), nullable=False)
    telephone: Mapped[str] = mapped_column(String(50), nullable=False)
    organisation: Mapped[str | None] = mapped_column(String(100), default="REIPE")
    province: Mapped[str] = mapped_column(String(100), nullable=False, index=True)
    ville: Mapped[str] = mapped_column(String(100), nullable=False)
    territoire: Mapped[str | None] = mapped_column(String(100), nullable=True)
    is_active: Mapped[bool | None] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime | None] = mapped_column(DateTime, default=datetime.now)

    # Relations
    clubs: Mapped[list["Club"]] = relationship(back_populates="encadreur")
    notifications: Mapped[list["EncadreurNotification"]] = relationship(
        back_populates="encadreur"
    )


class Club(Base):
    __tablename__ = "clubs"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    nom: Mapped[str] = mapped_column(String(150), nullable=False)
    province: Mapped[str] = mapped_column(String(100), nullable=False, index=True)
    ville: Mapped[str] = mapped_column(String(100), nullable=False)
    territoire: Mapped[str | None] = mapped_column(String(100), nullable=True)

    # encadreur_id : Clé étrangère vers la table "encadreurs", nullable.
    encadreur_id: Mapped[str | None] = mapped_column(
        String(50), ForeignKey("encadreurs.id"), nullable=True
    )
    created_at: Mapped[datetime | None] = mapped_column(DateTime, default=datetime.now)

    # Relations
    # encadreur : Relation vers la classe "Encadreur" (côté "plusieurs").
    encadreur: Mapped["Encadreur"] = relationship(back_populates="clubs")
    # adolescents : Relation vers la classe "Adolescent" (côté "plusieurs").
    adolescents: Mapped[list["Adolescent"]] = relationship(back_populates="club")


class Adolescent(Base):
    __tablename__ = "adolescents"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    prenom: Mapped[str] = mapped_column(String(100), nullable=False)
    age: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    sexe: Mapped[str] = mapped_column(String(10), nullable=False, index=True)
    province: Mapped[str] = mapped_column(String(100), nullable=False, index=True)
    ville: Mapped[str] = mapped_column(String(100), nullable=False, index=True)
    territoire: Mapped[str | None] = mapped_column(String(100), nullable=True)
    milieu: Mapped[str] = mapped_column(
        String(20), nullable=False, default="Urbain", index=True
    )
    statut_scolaire: Mapped[str | None] = mapped_column(
        String(50), default="Scolarisé", index=True
    )
    handicap: Mapped[bool | None] = mapped_column(Boolean, default=False, index=True)
    description_handicap: Mapped[str | None] = mapped_column(String(200), nullable=True)
    langue_preferee: Mapped[str | None] = mapped_column(
        String(50), default="Français", index=True
    )
    telephone: Mapped[str] = mapped_column(String(50), nullable=False)
    telephone_parent: Mapped[str] = mapped_column(String(50), nullable=False)

    # club_id : Clé étrangère vers la table "clubs", nullable et indexée.
    club_id: Mapped[str | None] = mapped_column(
        String(50), ForeignKey("clubs.id"), nullable=True, index=True
    )

    # canal_inscription : Enum CanalInscriptionEnum, non nul et indexé.
    canal_inscription: Mapped[CanalInscriptionEnum] = mapped_column(
        Enum(CanalInscriptionEnum), nullable=False, index=True
    )

    # statut_inscription : Enum StatutInscriptionEnum, indexé, avec valeur par défaut.
    statut_inscription: Mapped[StatutInscriptionEnum] = mapped_column(
        Enum(StatutInscriptionEnum),
        default=StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION,
        index=True,
    )

    # statut_consentement : Enum StatutConsentementEnum, indexé, avec valeur par défaut.
    statut_consentement: Mapped[StatutConsentementEnum] = mapped_column(
        Enum(StatutConsentementEnum),
        default=StatutConsentementEnum.EN_ATTENTE,
        index=True,
    )
    # mode_consentement : Chaîne de caractères, limitée à 50, défaut "SMS / WhatsApp".
    mode_consentement: Mapped[str] = mapped_column(String(50), default="SMS / WhatsApp")
    points_xp: Mapped[int] = mapped_column(Integer, default=0)
    certifie: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    code_certificat: Mapped[str | None] = mapped_column(
        String(100), nullable=True, unique=True
    )
    anonymise: Mapped[bool | None] = mapped_column(Boolean, default=False)
    date_inscription: Mapped[datetime | None] = mapped_column(
        DateTime, default=datetime.now, index=True
    )
    date_validation_encadreur: Mapped[datetime | None] = mapped_column(
        DateTime, nullable=True
    )

    # Relations
    # club : Relation vers la classe "Club" (côté "plusieurs").
    club: Mapped["Club"] = relationship(back_populates="adolescents")

    # reportages : Relation vers la classe "Reportage" (côté "un").
    reportages: Mapped[list["Reportage"]] = relationship(back_populates="auteur")


class EncadreurNotification(Base):
    __tablename__ = "encadreur_notifications"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    encadreur_id: Mapped[str] = mapped_column(
        String(50), ForeignKey("encadreurs.id"), nullable=False, index=True
    )
    adolescent_id: Mapped[str | None] = mapped_column(
        String(50), ForeignKey("adolescents.id"), nullable=True, index=True
    )
    type_notification: Mapped[str] = mapped_column(
        String(50), default="NOUVELLE_INSCRIPTION"
    )
    titre: Mapped[str] = mapped_column(String(200), nullable=False)
    message: Mapped[str] = mapped_column(Text, nullable=False)
    is_read: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.now, index=True
    )
    # Relation
    # encadreur : Relation vers la classe "Encadreur" (côté "plusieurs").
    encadreur: Mapped["Encadreur"] = relationship(back_populates="notifications")


class Reportage(Base):
    __tablename__ = "reportages"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    auteur_id: Mapped[str] = mapped_column(
        String(50), ForeignKey("adolescents.id"), nullable=False, index=True
    )
    titre: Mapped[str] = mapped_column(String(250), nullable=False)
    contenu: Mapped[str] = mapped_column(Text, nullable=False)
    type_media: Mapped[str | None] = mapped_column(String(50), default="article")
    media_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    theme: Mapped[str | None] = mapped_column(String(100), default="Droits de l'enfant")
    statut: Mapped[StatutReportageEnum | None] = mapped_column(
        Enum(StatutReportageEnum),
        default=StatutReportageEnum.SOUMIS_N1,
        index=True,
    )
    avis_encadreur: Mapped[str | None] = mapped_column(Text, nullable=True)
    relecture_ponabana: Mapped[str | None] = mapped_column(Text, nullable=True)
    exif_purge: Mapped[bool | None] = mapped_column(Boolean, default=True)
    floutage_actif: Mapped[bool | None] = mapped_column(Boolean, default=True)
    consentement_interviewes: Mapped[bool | None] = mapped_column(Boolean, default=True)
    date_soumission: Mapped[datetime | None] = mapped_column(
        DateTime, default=datetime.now, index=True
    )
    date_publication: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)

    # wordpress_post_id : Entier, nullable.
    wordpress_post_id: Mapped[int | None] = mapped_column(Integer, nullable=True)

    # Relation
    # auteur : Relation vers la classe "Adolescent" (côté "plusieurs").
    auteur: Mapped["Adolescent"] = relationship(back_populates="reportages")


class IncidentSauvegarde(Base):
    __tablename__ = "incidents_sauvegarde"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, index=True)
    signaleur_type: Mapped[str | None] = mapped_column(String(50), default="Adolescent")
    signaleur_contact: Mapped[str | None] = mapped_column(String(100), nullable=True)
    type_incident: Mapped[str] = mapped_column(String(100), nullable=False)
    gravite: Mapped[str | None] = mapped_column(String(20), default="URGENT")
    description: Mapped[str] = mapped_column(Text, nullable=False)
    province: Mapped[str] = mapped_column(String(100), nullable=False)
    statut: Mapped[str | None] = mapped_column(String(50), default="SIGNALÉ_SLA_24H")
    date_signalement: Mapped[datetime | None] = mapped_column(
        DateTime, default=datetime.now
    )
    point_focal_assigne: Mapped[str | None] = mapped_column(
        String(100), default="Point Focal PSE UNICEF RDC"
    )


class AuditLog(Base):
    __tablename__ = "audit_logs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[str] = mapped_column(String(50), nullable=False)
    user_role: Mapped[str] = mapped_column(String(50), nullable=False)
    action: Mapped[str] = mapped_column(String(100), nullable=False)
    details: Mapped[str] = mapped_column(Text, nullable=False)
    ip_address: Mapped[str | None] = mapped_column(String(50), default="127.0.0.1")
    timestamp: Mapped[datetime | None] = mapped_column(
        DateTime, default=datetime.now, index=True
    )
