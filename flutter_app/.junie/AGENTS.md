Développement des outils digitaux d'identification, d'inscription, de formation, de suivi et
d'évaluation des adolescents engagés dans le plaidoyer pour les droits de l'enfant et la
documentation des enfants reporters
UNICEF République Démocratique du Congo – Programme pays de Développement 2025
2029
1. Contexte et justification
   Dans le cadre du CPD 2025–2029, l'UNICEF RDC et ses partenaires (REIPE, Ministère du
   Genre, Enfant et Famille, Ministère des Affaires sociales, Ministère de l'Éducation
   nationale) mettent en œuvre une stratégie de redynamisation de l'engagement des
   adolescents de 12 à 17 ans. Cette stratégie repose sur la digitalisation du parcours de
   l'adolescent engagé : mobilisation, inscription, consentement parental, formation
   théorique, certification, intégration dans une communauté d'engagement, production de
   contenus médiatiques et suivi longitudinal.
   Les outils développés seront déployés en novembre–décembre 2026 pour une première
   vague d'inscription à grande échelle, puis étendus progressivement à sept villes (2027),
   sept provinces (2028) et l'ensemble des 26 provinces (2029). Ils devront fonctionner dans
   un contexte de connectivité limitée et coûteuse, de diversité linguistique et de forte
   exigence en matière de sauvegarde de l'enfant et de protection des données personnelles.
   Le présent cahier des charges définit les attentes de l'UNICEF à l'égard du prestataire de
   services chargé de la conception, du développement, du déploiement et de
   l'accompagnement initial de ces outils.
2. Objectifs de la prestation - Objectif général : concevoir et déployer un écosystème digital unifié, inclusif et sécurisé
   permettant d'inscrire, former, certifier, animer, suivre et évaluer les adolescents engagés
   dans le plaidoyer pour les droits de l'enfant et les enfants reporters, à l'échelle nationale. - Objectifs spécifiques : - Développer un parcours d'inscription multicanal (web, WhatsApp, SMS/USSD) intégrant
   le consentement parental.
- Développer une plateforme de formation interactive à faible bande passante, multilingue
  et accessible, avec certification automatique. - Développer une base de données unique et sécurisée des adolescents engagés, avec un
  tableau de bord de suivi désagrégé. - Développer un espace de soumission et de validation éditoriale des contenus des enfants
  reporters, interopérable avec le blog Ponabana. - Assurer l'interopérabilité avec les outils existants de l'UNICEF (RapidPro/U-Report,
  KoboToolbox, WordPress Ponabana). - Transférer les compétences aux équipes de l'UNICEF et des partenaires pour
  l'administration et la maintenance des outils.
  Périmètre de la prestation
  Inclus dans le périmètre - Analyse des besoins, ateliers de co-conception avec les adolescents, le REIPE et les
  ministères partenaires. - Conception UX/UI adaptée aux adolescents, mobile-first et à faible connectivité. - Développement, intégration, tests et mise en production de l'ensemble des modules
  décrits à la section 5. - Intégration des contenus pédagogiques fournis par l'UNICEF (textes, scripts, quiz) et
  production des versions interactives. - Hébergement de transition, documentation technique et fonctionnelle, formation des
  administrateurs. - Garantie, maintenance corrective et évolutive pendant 12 mois après la mise en
  production.
  Exclus du périmètre - Rédaction du contenu pédagogique des modules (assurée par l'UNICEF et ses
  partenaires ; le prestataire assure l'adaptation au format digital). - Traduction des contenus en langues nationales (assurée par l'UNICEF ; le prestataire
  assure l'intégration multilingue). - Gestion des campagnes publicitaires sur les réseaux sociaux. - Acquisition des équipements des enfants reporters.
4. Utilisateurs cibles

Profil  Besoins principaux  Contraintes à prendre en
compte
Adolescents (12–17 ans) S'inscrire facilement, se
former, obtenir un certificat,
rejoindre une communauté,
soumettre des contenus
Téléphone souvent partagé
ou basique, données
coûteuses, faible littératie
numérique, langues
nationales
Parents / tuteurs Comprendre le programme,
donner ou retirer leur
consentement
Accès limité au digital,
besoin de messages
simples en langue locale
Jeunes encadreurs REIPE Valider les inscriptions hors
ligne, animer les groupes,
suivre les adolescents,
valider les contenus au
premier niveau
Travail de terrain, connexion
intermittente, collecte via
smartphone
Comité éditorial et
rédaction Ponabana
Valider, éditer et publier les
contenus, suivre le
calendrier éditorial
Circuit de validation à deux
niveaux, traçabilité
Divisions provinciales des
ministères
Consulter les données de
leur province, délivrer les
certificats
Capacités techniques
hétérogènes
UNICEF (sections C&A,
programmes sectoriels,
PSE)
Piloter, suivre les
indicateurs, mobiliser les
adolescents pour les
campagnes sectorielles
Besoin de données
désagrégées, exports,
interopérabilité  
Administrateurs système Gérer les utilisateurs, les
rôles, les contenus, la
sécurité
Autonomie après transfert


5. Spécifications fonctionnelles

Module 1 : Mobilisation et inscription multicanale - Formulaire d'inscription web responsive, léger (moins de 500 Ko par page), accessible via
lien unique et code QR. - Chatbot WhatsApp d'inscription et d'orientation, développé sur RapidPro (infrastructure
U-Report existante), en français et en quatre langues nationales (lingala, swahili, tshiluba,
kikongo). - Parcours d'inscription par SMS et USSD pour les téléphones basiques, avec collecte des
données minimales. - Collecte de données limitée au strict nécessaire : prénom, âge, sexe, province,
ville/territoire, milieu (urbain/rural), statut scolaire, situation de handicap (déclaratif et
facultatif), langue préférée, numéro de téléphone de contact (de l'adolescent ou du
parent). - Vérification automatique de l'âge (12–17 ans) et redirection des personnes hors tranche
d'âge vers des ressources adaptées. - Mode « inscription assistée » pour les encadreurs REIPE et les relais des ministères,
permettant d'inscrire des adolescents hors ligne avec synchronisation ultérieure. - Génération d'un identifiant unique par adolescent, non signifiant et non réutilisable.
Module 2 : Consentement parental et sauvegarde - Envoi automatique d'un message explicatif au parent ou tuteur (SMS ou WhatsApp) dans
la langue choisie, avec possibilité de valider, refuser ou demander des informations. - Consentement par réponse SMS/WhatsApp, par formulaire web ou par consentement
papier numérisé et téléversé par un encadreur habilité. - Blocage automatique de l'accès à la communauté et à la soumission de contenus tant
que le consentement n'est pas validé. - Possibilité de retrait du consentement à tout moment, entraînant la désactivation du
compte et l'anonymisation des données selon la procédure définie. - Bouton de signalement visible sur toutes les interfaces destinées aux adolescents, avec
routage vers les points focaux sauvegarde désignés par l'UNICEF et notification sous 24
heures. - Journal des incidents de sauvegarde avec suivi du traitement et des délais.
Module 3 : Formation théorique interactive et certification - Six modules de formation (droits de l'enfant, tactiques de plaidoyer du guide pratique,
journalisme citoyen, vérification des faits, sécurité numérique, éthique et cadre éditorial),
chacun d'une durée de 10 à 15 minutes. - Formats intégrés : vidéos sous-titrées compressées (version 240p disponible), capsules
audio, fiches illustrées, exercices interactifs et quiz. - Mode hors ligne : téléchargement des modules pour consultation sans connexion, avec
synchronisation de la progression et des résultats au retour de la connexion (application
web progressive ou application Android légère inférieure à 20 Mo). - Suivi de la progression individuelle, reprise à l'endroit interrompu, rappels automatiques
par WhatsApp ou SMS. - Quiz à réussite conditionnelle (seuil paramétrable), avec possibilité de nouvelle tentative
et feedback pédagogique.
- Génération automatique d'un certificat numérique nominatif, avec code de vérification
  unique et version imprimable au format des divisions provinciales. - Parcours différenciés après certification : filière « Engagé au plaidoyer » et filière « enfant
  reporter », avec modules complémentaires. - Système de gestion des contenus pédagogiques permettant à l'UNICEF de mettre à jour
  les modules sans intervention du prestataire.
  Module 4 : Communautés d'engagement et suivi de terrain - Affectation automatique des adolescents certifiés aux groupes WhatsApp de leur ville ou
  territoire, avec génération de liens d'invitation sécurisés et contrôlés par les encadreurs. - Tableau de bord des encadreurs : liste des adolescents de leur zone, statut (inscrit,
  certifié, actif, inactif, sorti), historique des activités, alertes de décrochage. - Application de collecte terrain pour les encadreurs, développée ou intégrée avec
  KoboToolbox : enregistrement des ateliers pratiques, des présences, des campagnes de
  plaidoyer et des engagements obtenus des décideurs. - Module de gestion des campagnes de plaidoyer : fiche de campagne (thème, cible,
  tactiques, calendrier), affectation des adolescents participants, documentation des
  résultats et des engagements, suivi de leur mise en œuvre. - Gestion automatisée de la transition à 18 ans : notification, changement de statut vers le
  vivier des « anciens », proposition du parcours mentor ou encadreur. - Système de reconnaissance : badges numériques pour les étapes clés (première
  publication, première campagne, mentor), consultables par l'adolescent.
  Module 5 : Production, validation et diffusion des contenus des enfants reporters - Interface de soumission de contenus (texte, photo, audio, vidéo) adaptée au mobile, avec
  compression automatique et téléversement fractionné pour connexions instables. - Formulaire d'accompagnement obligatoire : titre, thème, lieu, date, sources, mention du
  consentement des personnes photographiées ou interviewées, déclaration de vérification
  des faits. - Circuit de validation à deux niveaux (encadreur, comité éditorial et de rédaction
  Ponabana) avec statuts, commentaires, demandes de modification et historique complet. - Contrôles automatiques de sauvegarde : détection des visages d'enfants pour alerte de
  floutage, suppression des métadonnées de géolocalisation, vérification de la présence des
  mentions de consentement. - Interopérabilité avec le blog Ponabana (WordPress) : publication directe des contenus
  validés via API, avec attribution paramétrable (prénom, pseudonyme ou anonymat). - Calendrier éditorial national partagé, avec planification par province et thématique. - Bibliothèque de contenus publiés avec métadonnées, recherche et export pour reprise
  par les médias partenaires.
  Module 6 : Base de données unique, tableau de bord et rapportage - Base de données centralisée et sécurisée de l'ensemble des adolescents, encadreurs,
  contenus, campagnes et incidents. - Tableau de bord national et provincial avec indicateurs en temps réel : inscrits,
  consentements validés, certifiés, taux d'achèvement, enfants reporters actifs, contenus
  soumis/publiés, campagnes menées, engagements obtenus, incidents de sauvegarde. - Désagrégation systématique par sexe, âge, province, ville/territoire, milieu, statut scolaire,
  situation de handicap, canal d'inscription et langue. - Suivi des indicateurs d'équité avec alertes lorsque les seuils cibles ne sont pas atteints. - Exports paramétrables (CSV, Excel) et API sécurisée pour intégration dans les systèmes
  de suivi-évaluation de l'UNICEF. - Rapports automatisés mensuels et trimestriels, alignés sur le cadre de résultats de la
  stratégie. - Statistiques d'audience et d'engagement digital des contenus (intégration des analytics
  du blog et des réseaux sociaux).
  Module 7 : Administration et gestion des accès - Gestion des rôles et permissions selon le principe du moindre privilège : adolescent,
  parent, encadreur, membre de comité éditorial et de rédaction Ponabana, division
  provinciale, UNICEF section C&A, UNICEF PSE, administrateur. - Cloisonnement des données par province pour les utilisateurs provinciaux. - Authentification forte pour tous les comptes adultes (mot de passe robuste et second
  facteur). - Journal d'audit de toutes les actions sensibles (consultation, modification, export,
  suppression de données). - Interface d'administration des contenus pédagogiques, des messages automatiques, des
  langues et des paramètres.
6. Exigences techniques et non fonctionnelles - Architecture : architecture modulaire orientée services, séparant l'interface utilisateur, la
   logique métier et la base de données ; documentation des API. - Interopérabilité : intégration native avec RapidPro/U-Report (inscription et messagerie),
   KoboToolbox (collecte terrain), WordPress Ponabana (publication) et les passerelles
   SMS/USSD des opérateurs congolais. - Faible bande passante : pages inférieures à 500 Ko, images optimisées, chargement
   progressif, fonctionnement démontré sur connexion 2G/3G ; mesure des coûts de données
   par parcours. - Fonctionnement hors ligne : application web progressive ou application Android légère
   avec stockage local et synchronisation différée pour les modules de formation,
   l'inscription assistée et la collecte terrain. - Multilinguisme : interface et contenus en français et quatre langues nationales, avec
   architecture permettant l'ajout de langues supplémentaires. - Accessibilité : conformité aux Web Content Accessibility Guidelines 2.1 niveau AA ;
   compatibilité avec les lecteurs d'écran ; sous-titres et transcriptions pour tout contenu
   audiovisuel ; contrastes et tailles de police adaptés. - Performance et disponibilité : temps de réponse inférieur à 3 secondes sur connexion 3G
   ; disponibilité de 99,5 % ; capacité à absorber 10 000 inscriptions par jour lors des
   campagnes. - Sécurité : chiffrement des données en transit (TLS 1.2 minimum) et au repos ; protection
   contre les vulnérabilités courantes (référentiel OWASP) ; tests d'intrusion avant mise en
   production ; sauvegardes quotidiennes chiffrées avec plan de reprise d'activité. - Hébergement : hébergement sur infrastructure conforme aux exigences de sécurité de
   l'UNICEF, avec possibilité de migration ; localisation des données et conditions
   contractuelles d'hébergement à documenter. - Technologies ouvertes : utilisation prioritaire de technologies open source et de
   standards ouverts, en cohérence avec l'approche « biens publics numériques » de
   l'UNICEF ; absence de dépendance à des licences propriétaires récurrentes. - Scalabilité : capacité à passer de 25 000 utilisateurs en 2026 à plus de 100 000 en 2029
   sans refonte. - Compatibilité : navigateurs mobiles courants, Android à partir de la version 8, téléphones
   basiques pour les canaux SMS/USSD.
7. Sauvegarde de l'enfant et protection des données personnelles - Cadre de référence : respect de la politique de sauvegarde de l'enfant de l'UNICEF, de la
   politique de protection des données personnelles de l'UNICEF et du cadre légal congolais
   applicable. - Minimisation des données : collecte limitée aux données strictement nécessaires ;
   interdiction de collecter des données sensibles non prévues au présent cahier des
   charges. - Consentement : aucun traitement de données d'un adolescent sans consentement
   parental validé ; information claire et adaptée à l'âge. - Pseudonymisation : les données d'identification sont séparées des données d'activité et
   accessibles uniquement aux rôles habilités. - Conservation : durées de conservation définies avec l'UNICEF ; anonymisation
   automatique à la sortie du programme ou à la demande. - Analyse d'impact : le prestataire réalise, avec l'UNICEF, une analyse d'impact relative à la
   protection des données et à la sauvegarde avant la mise en production. - Engagements du personnel : l'ensemble du personnel du prestataire en contact avec les
   données ou les adolescents signe le code de conduite et les engagements de sauvegarde
   de l'UNICEF et fournit une attestation de vérification d'antécédents. - Gestion des incidents : procédure de notification de toute violation de données ou
   incident de sauvegarde à l'UNICEF dans un délai maximal de 24 heures.
8. Méthodologie attendue - Approche agile et itérative : livraisons par incréments fonctionnels, avec démonstrations
   à la fin de chaque itération et priorisation conjointe avec l'UNICEF. - Co-conception avec les utilisateurs : au moins trois ateliers de conception avec des
   adolescents (filles et garçons, milieux urbain et rural, adolescents vivant avec un
   handicap), le REIPE et les ministères. - Tests utilisateurs : tests en conditions réelles à Kinshasa et Lubumbashi avec des
   adolescents et des encadreurs avant la mise en production, incluant des tests sur
   téléphones basiques et en connexion dégradée. - Produit minimum viable : priorisation des modules 1, 2, 3 et 6 pour la campagne
   d'inscription de novembre 2026 ; modules 4, 5 et 7 finalisés avant la phase de capacitation
   pratique du premier trimestre 2027. - Assurance qualité : tests fonctionnels, de charge, de sécurité et d'accessibilité
   documentés ; recette formelle par l'UNICEF pour chaque livrable.
9. Livrables
   N°  Livrable
   Contenu
   L1 Rapport de cadrage Analyse des besoins, architecture
   cible, backlog priorisé, plan de travail
   détaillé
   Échéance indicative
   T0 + 2 semaines
   L2 Maquettes et
   prototype
   Maquettes UX/UI validées avec les
   adolescents, prototype navigable
   L3 Produit minimum
   viable
   Modules 1, 2, 3 et 6 opérationnels,
   testés et mis en production
   T0 + 4 semaines
   T0 + 6 semaines
   (avant novembre
2026)
L4 Version complète
L5 Documentation
Modules 4, 5 et 7 opérationnels,
intégrations finalisées
T0 + 10 semaines
Documentation technique, guide
d'administration, guides utilisateurs
par profil, code source commenté
L6 Formation et
transfert
Avec L4
Formation des administrateurs
UNICEF et ministères, des encadreurs
formateurs et des comités éditoriaux ;
supports de formation
L7 Rapport de sécurité
et de protection
des données
Résultats des tests d'intrusion,
analyse d'impact, plan de correction
T0 + 12 semaines
Avant chaque mise
en production
L8 Rapports de
maintenance
Rapports trimestriels de disponibilité,
incidents, corrections et évolutions
L9 Rapport de clôture Bilan, leçons apprises,
recommandations de passage à
l'échelle 2028–2029
Pendant 12 mois
après L4
Fin de la période de
maintenance
10. Calendrier et jalons - T0 : signature du contrat et réunion de démarrage. - T0 + 2 semaines : validation du cadrage et de l'architecture. - T0 + 4 semaines : validation des maquettes après tests avec les adolescents. - T0 + 5 semaines : recette du produit minimum viable en environnement de test. - T0 + 6 semaines : mise en production du produit minimum viable pour la campagne
    d'inscription de novembre–décembre 2026. - T0 + 10 semaines : mise en production de la version complète avant la capacitation
    pratique du premier trimestre 2027. - T0 + 12 semaines : achèvement du transfert de compétences. - T0 + 20 semaines à T0 + 22 semaines : garantie et maintenance, incluant les adaptations
    nécessaires à l'extension aux territoires en 2028.
11. Gouvernance de la prestation - Comité technique : réunion hebdomadaire entre le chef de projet du prestataire et le
    point focal UNICEF (section C&A Point Focal Engagement des adolescents), avec
    participation du point focal technologie pour le développement (T4D) et du point focal
    sauvegarde. - Comité de validation : réunion à chaque jalon avec l'UNICEF, le REIPE et les représentants
    des ministères pour la recette des livrables. - Implication des adolescents : une délégation d'adolescents est associée aux ateliers de
    conception et aux tests utilisateurs, dans le respect des règles de sauvegarde. - Rapportage : rapport d'avancement bimensuel synthétique, registre des risques et des
    décisions tenu à jour. - Gestion des changements : toute modification de périmètre fait l'objet d'une demande
    formelle validée par l'UNICEF.
12. Profil et compétences du prestataire - Expérience : au moins cinq années dans le développement de plateformes digitales, avec
    au moins deux références de plateformes d'apprentissage ou d'engagement déployées
    dans des contextes à faible connectivité, de préférence en Afrique subsaharienne. - Compétences techniques : maîtrise démontrée de RapidPro ou de plateformes de
    messagerie équivalentes, de l'intégration WordPress et KoboToolbox, du développement
    d'applications web progressives ou Android légères, des passerelles SMS/USSD. - Expérience sectorielle : expérience de travail avec des enfants ou des adolescents et
    connaissance des principes de sauvegarde ; expérience avec les agences des Nations
    Unies ou les ONG internationales appréciée. - Équipe minimale : chef de projet, concepteur UX/UI, développeurs front-end et back-end,
    spécialiste sécurité et protection des données, spécialiste accessibilité, formateur ;
    présence d'au moins un membre de l'équipe basé en RDC ou capacité démontrée
    d'intervention sur place. - Compétences linguistiques : maîtrise du français ; capacité à intégrer et tester des
    contenus en langues nationales congolaises. - Conformité : acceptation du code de conduite des fournisseurs des Nations Unies et de
    la politique de sauvegarde de l'enfant de l'UNICEF.
13. Contenu attendu de l'offre - Offre technique : compréhension du contexte et des enjeux d'équité, architecture
    proposée, description des modules, approche méthodologique, plan de travail et jalons,
    plan de gestion des risques, plan de sauvegarde et de protection des données, plan de
    transfert de compétences, composition de l'équipe et curriculum vitæ, références
    vérifiables. - Offre financière : budget détaillé par livrable et par phase, coûts d'hébergement et de
    maintenance pour 12 mois, coûts optionnels d'extension (langues supplémentaires,
    modules additionnels), conditions de paiement liées aux jalons.
- Documents administratifs : enregistrement légal, attestations fiscales, engagements de
  conformité aux politiques de l'UNICEF.
14. Critères d'évaluation des offres
    Critère
    Compréhension du contexte et pertinence de l'approche, y compris
    inclusion et faible connectivité
    Pondération
    20 %
    Qualité de l'architecture technique, interopérabilité et respect des
    exigences non fonctionnelles
    20 %
    Dispositif de sauvegarde de l'enfant et de protection des données
    Expérience et références du prestataire dans des contextes comparables 15 %
    15 %
    Qualité de l'équipe proposée et présence en RDC
    Plan de transfert de compétences et de durabilité
    10 %
    10 %
    Offre financière
    10 %
    Seules les offres techniques atteignant un score minimal de 70 % seront considérées pour
    l'évaluation financière.
15. Propriété intellectuelle et conditions particulières - Propriété : l'ensemble des développements, du code source, de la documentation et des
    contenus produits dans le cadre de la prestation est la propriété de l'UNICEF, qui pourra
    les publier en tant que biens publics numériques sous licence ouverte. - Confidentialité : le prestataire s'engage à la confidentialité absolue des données traitées
    et s'interdit toute réutilisation à des fins autres que la prestation. - Réversibilité : le prestataire garantit la fourniture de l'ensemble des éléments nécessaires
    à la reprise de la plateforme par l'UNICEF ou un tiers (code, bases de données,
    configurations, procédures) au terme de la prestation. - Non-conformité : tout manquement aux exigences de sauvegarde de l'enfant ou de
    protection des données constitue un motif de résiliation immédiate.
16. Annexes à fournir aux soumissionnaires - Annexe 1 : stratégie de redynamisation de l'engagement des adolescents 2026–2029
    (version validée). - Annexe 2 : cadre éditorial et éthique commun (projet). - Annexe 3 : plan des six modules de formation et scripts disponibles. - Annexe 4 : politique de sauvegarde de l'enfant et politique de protection des données
    personnelles de l'UNICEF. - Annexe 5 : description de l'infrastructure existante (RapidPro/U-Report, KoboToolbox,
    WordPress Ponabana) et points de contact techniques. - Annexe 6 : cadre de résultats et liste des indicateurs à intégrer au tableau de bord. - Annexe 7 : modèle d'offre financière.