4\. Utilisateurs cibles 

&#x20;

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

UNICEF (sections C\&A, 

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

&#x20;

&#x20;

5\. Spécifications fonctionnelles 

&#x20;

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

\- Génération automatique d'un certificat numérique nominatif, avec code de vérification 

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

provinciale, UNICEF section C\&A, UNICEF PSE, administrateur. - Cloisonnement des données par province pour les utilisateurs provinciaux. - Authentification forte pour tous les comptes adultes (mot de passe robuste et second 

facteur). - Journal d'audit de toutes les actions sensibles (consultation, modification, export, 

suppression de données). - Interface d'administration des contenus pédagogiques, des messages automatiques, des 

langues et des paramètres. 

6\. Exigences techniques et non fonctionnelles - Architecture : architecture modulaire orientée services, séparant l'interface utilisateur, la 

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

