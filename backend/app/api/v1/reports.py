import io
import csv
from typing import Dict, Any, Optional
from fastapi import APIRouter, Depends, Response
from sqlalchemy.orm import Session
from sqlalchemy import func
from backend.app.db.session import get_db
from backend.app.models.models import Adolescent, StatutInscriptionEnum, CanalInscriptionEnum
from backend.app.schemas.schemas import DisaggregatedReportResponse
from backend.app.api.v1.auth import require_encadreur_or_admin

router = APIRouter(prefix="/reports", tags=["Rapportage & Tableau de bord désagrégé"])

@router.get("/disaggregated", response_model=DisaggregatedReportResponse)
def get_disaggregated_report(
    province: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """
    Génère les indicateurs désagrégés en temps réel :
    - Sexe (Parité filles/garçons)
    - Canaux / Origines d'inscriptions (USSD, Chatbot WhatsApp, Web, SMS, Inscription assistée)
    - Zones / Provinces / Territoires
    - Milieu (Urbain vs Rural)
    - Inclusivité (Handicap, Statut scolaire, Langues)
    """
    query = db.query(Adolescent)
    if province:
        query = query.filter(Adolescent.province.ilike(f"%{province}%"))

    ados = query.all()
    total = len(ados)

    total_confirmes = sum(1 for a in ados if a.statut_inscription == StatutInscriptionEnum.CONFIRMED)
    total_en_attente = sum(1 for a in ados if a.statut_inscription == StatutInscriptionEnum.PENDING_ENCADREUR_VALIDATION)
    total_rejetes = sum(1 for a in ados if a.statut_inscription == StatutInscriptionEnum.REJECTED)
    total_certifies = sum(1 for a in ados if a.certifie)

    # Répartition par Sexe
    count_filles = sum(1 for a in ados if a.sexe.upper() == "F")
    count_garcons = sum(1 for a in ados if a.sexe.upper() == "M")
    pct_filles = round((count_filles / total * 100), 1) if total > 0 else 50.0
    alerte_parite = pct_filles < 45.0 or pct_filles > 55.0

    # Répartition par Canal d'Origine
    canaux_dict = {
        "USSD": sum(1 for a in ados if a.canal_inscription == CanalInscriptionEnum.USSD),
        "CHATBOT_RAPIDPRO": sum(1 for a in ados if a.canal_inscription == CanalInscriptionEnum.CHATBOT_RAPIDPRO),
        "WEB": sum(1 for a in ados if a.canal_inscription == CanalInscriptionEnum.WEB),
        "SMS": sum(1 for a in ados if a.canal_inscription == CanalInscriptionEnum.SMS),
        "ASSISTED_REIPE": sum(1 for a in ados if a.canal_inscription == CanalInscriptionEnum.ASSISTED_REIPE),
    }

    # Répartition par Province
    provinces_dict = {}
    for a in ados:
        prov = a.province or "Inconnue"
        provinces_dict[prov] = provinces_dict.get(prov, 0) + 1

    # Répartition par Milieu
    count_urbain = sum(1 for a in ados if "urbain" in a.milieu.lower() and "péri" not in a.milieu.lower())
    count_rural = sum(1 for a in ados if "rural" in a.milieu.lower() or "péri" in a.milieu.lower())
    pct_rural = round((count_rural / total * 100), 1) if total > 0 else 0.0

    # Répartition par Statut Scolaire
    scolaire_dict = {}
    for a in ados:
        stat = a.statut_scolaire or "Non renseigné"
        scolaire_dict[stat] = scolaire_dict.get(stat, 0) + 1

    # Répartition par Handicap
    count_handicap = sum(1 for a in ados if a.handicap)
    count_sans_handicap = total - count_handicap

    # Répartition par Langue
    langues_dict = {}
    for a in ados:
        lang = a.langue_preferee or "Français"
        langues_dict[lang] = langues_dict.get(lang, 0) + 1

    return DisaggregatedReportResponse(
        total_inscriptions=total,
        total_confirmes=total_confirmes,
        total_en_attente_validation=total_en_attente,
        total_rejetes=total_rejetes,
        total_certifies=total_certifies,
        repartition_sexe={"F": count_filles, "M": count_garcons},
        pourcentage_filles=pct_filles,
        alerte_parite_50_50=alerte_parite,
        repartition_canaux=canaux_dict,
        repartition_provinces=provinces_dict,
        repartition_milieu={"Urbain": count_urbain, "Rural": count_rural},
        pourcentage_rural=pct_rural,
        repartition_statut_scolaire=scolaire_dict,
        repartition_handicap={"avec_handicap": count_handicap, "sans_handicap": count_sans_handicap},
        repartition_langues=langues_dict
    )

@router.get("/export-csv")
def export_csv(
    db: Session = Depends(get_db)
):
    """
    Exporte la base complète désagrégée au format CSV pour ingestion dans DEVINFO / RAM UNICEF.
    """
    ados = db.query(Adolescent).all()
    output = io.StringIO()
    writer = csv.writer(output)

    # En-têtes CSV
    writer.writerow([
        "ID_Adolescent", "Prenom", "Age", "Sexe", "Province", "Ville", "Milieu",
        "Statut_Scolaire", "Situation_Handicap", "Langue", "Canal_Origine",
        "Statut_Inscription", "Date_Inscription", "Statut_Consentement", "Certifie", "Code_Certificat"
    ])

    for a in ados:
        writer.writerow([
            a.id,
            a.prenom if not a.anonymise else "ANONYME",
            a.age,
            a.sexe,
            a.province,
            a.ville,
            a.milieu,
            a.statut_scolaire,
            "OUI" if a.handicap else "NON",
            a.langue_preferee,
            a.canal_inscription.value,
            a.statut_inscription.value,
            a.date_inscription.strftime("%Y-%m-%d %H:%M:%S") if a.date_inscription else "",
            a.statut_consentement.value,
            "OUI" if a.certifie else "NON",
            a.code_certificat or ""
        ])

    csv_data = output.getvalue()
    return Response(
        content=csv_data,
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=unicef_rdc_rapport_adolescents_desagrege.csv"}
    )
