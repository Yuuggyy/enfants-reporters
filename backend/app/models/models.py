import enum
from datetime import datetime
from sqlalchemy import (
    Column, String, Integer, Boolean, DateTime, ForeignKey, Text, Enum, Float
)
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

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

class AdminUser(Base):
    __tablename__ = "admin_users"

    id = Column(String(50), primary_key=True, index=True)
    email = Column(String(120), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    prenom = Column(String(100), nullable=False)
    nom = Column(String(100), nullable=False)
    section = Column(String(100), default="UNICEF C&A (Communication & Plaidoyer)")
    role_titre = Column(String(100), default="Administrateur National")
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class Encadreur(Base):
    __tablename__ = "encadreurs"

    id = Column(String(50), primary_key=True, index=True)
    email = Column(String(120), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    prenom = Column(String(100), nullable=False)
    nom = Column(String(100), nullable=False)
    telephone = Column(String(50), nullable=False)
    organisation = Column(String(100), default="REIPE")
    province = Column(String(100), nullable=False, index=True)
    ville = Column(String(100), nullable=False)
    territoire = Column(String(100), nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    clubs = relationship("Club", back_populates="encadreur")
    notifications = relationship("EncadreurNotification", back_populates="encadreur")

class Club(Base):
    __tablename__ = "clubs"

    id = Column(String(50), primary_key=True, index=True)
    nom = Column(String(150), nullable=False)
    province = Column(String(100), nullable=False, index=True)
    ville = Column(String(100), nullable=False)
    territoire = Column(String(100), nullable=True)
    encadreur_id = Column(String(50), ForeignKey("encadreurs.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    encadreur = relationship("Encadreur", back_populates="clubs")
    adolescents = relationship("Adolescent", back_populates="club")

class Adolescent(Base):
    __tablename__ = "adolescents"

    id = Column(String(50), primary_key=True, index=True)
    prenom = Column(String(100), nullable=False)
    age = Column(Integer, nullable=False, index=True)
    sexe = Column(String(10), nullable=False, index=True)  # F / M
    province = Column(String(100), nullable=False, index=True)
    ville = Column(String(100), nullable=False, index=True)
    territoire = Column(String(100), nullable=True)
    milieu = Column(String(20), nullable=False, default="Urbain", index=True)  # Urbain / Rural
    statut_scolaire = Column(String(50), default="Scolarisé", index=True)
    handicap = Column(Boolean, default=False, index=True)
    description_handicap = Column(String(200), nullable=True)
    langue_preferee = Column(String(50), default="Français", index=True)
    telephone = Column(String(50), nullable=False)
    telephone_parent = Column(String(50), nullable=False)
    
    club_id = Column(String(50), ForeignKey("clubs.id"), nullable=True, index=True)
    canal_inscription = Column(Enum(CanalInscriptionEnum), nullable=False, index=True)
    statut_inscription = Column(Enum(StatutInscriptionEnum), default=StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION, index=True)
    statut_consentement = Column(Enum(StatutConsentementEnum), default=StatutConsentementEnum.EN_ATTENTE, index=True)
    mode_consentement = Column(String(50), default="SMS / WhatsApp")
    
    points_xp = Column(Integer, default=0)
    certifie = Column(Boolean, default=False, index=True)
    code_certificat = Column(String(100), nullable=True, unique=True)
    anonymise = Column(Boolean, default=False)
    date_inscription = Column(DateTime, default=datetime.utcnow, index=True)
    date_validation_encadreur = Column(DateTime, nullable=True)

    club = relationship("Club", back_populates="adolescents")
    reportages = relationship("Reportage", back_populates="auteur")

class EncadreurNotification(Base):
    __tablename__ = "encadreur_notifications"

    id = Column(String(50), primary_key=True, index=True)
    encadreur_id = Column(String(50), ForeignKey("encadreurs.id"), nullable=False, index=True)
    adolescent_id = Column(String(50), ForeignKey("adolescents.id"), nullable=True, index=True)
    type_notification = Column(String(50), default="NOUVELLE_INSCRIPTION")
    titre = Column(String(200), nullable=False)
    message = Column(Text, nullable=False)
    is_read = Column(Boolean, default=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    encadreur = relationship("Encadreur", back_populates="notifications")

class Reportage(Base):
    __tablename__ = "reportages"

    id = Column(String(50), primary_key=True, index=True)
    auteur_id = Column(String(50), ForeignKey("adolescents.id"), nullable=False, index=True)
    titre = Column(String(250), nullable=False)
    contenu = Column(Text, nullable=False)
    type_media = Column(String(50), default="article")  # article, photo, audio, video
    media_url = Column(String(500), nullable=True)
    theme = Column(String(100), default="Droits de l'enfant")
    statut = Column(Enum(StatutReportageEnum), default=StatutReportageEnum.SOUMIS_N1, index=True)
    avis_encadreur = Column(Text, nullable=True)
    relecture_ponabana = Column(Text, nullable=True)
    exif_purge = Column(Boolean, default=True)
    floutage_actif = Column(Boolean, default=True)
    consentement_interviewes = Column(Boolean, default=True)
    date_soumission = Column(DateTime, default=datetime.utcnow, index=True)
    date_publication = Column(DateTime, nullable=True)
    wordpress_post_id = Column(Integer, nullable=True)

    auteur = relationship("Adolescent", back_populates="reportages")

class IncidentSauvegarde(Base):
    __tablename__ = "incidents_sauvegarde"

    id = Column(String(50), primary_key=True, index=True)
    signaleur_type = Column(String(50), default="Adolescent")
    signaleur_contact = Column(String(100), nullable=True)
    type_incident = Column(String(100), nullable=False)
    gravite = Column(String(20), default="URGENT")  # NORMAL, URGENT, CRITIQUE
    description = Column(Text, nullable=False)
    province = Column(String(100), nullable=False)
    statut = Column(String(50), default="SIGNALÉ_SLA_24H")
    date_signalement = Column(DateTime, default=datetime.utcnow)
    point_focal_assigne = Column(String(100), default="Point Focal PSE UNICEF RDC")

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(50), nullable=False)
    user_role = Column(String(50), nullable=False)
    action = Column(String(100), nullable=False)
    details = Column(Text, nullable=False)
    ip_address = Column(String(50), default="127.0.0.1")
    timestamp = Column(DateTime, default=datetime.utcnow, index=True)
