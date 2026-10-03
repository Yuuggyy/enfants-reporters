/**
 * Base de données mockée unifiée pour le projet UNICEF RDC
 * Engagement des adolescents et Enfants Reporters (2025-2029)
 */

export const INITIAL_DATABASE = {
  provinces: [
    { id: 'kinshasa', nom: 'Kinshasa', chefLieu: 'Kinshasa', cibleAdos: 25000, quotaFilles: 52 },
    { id: 'haut_katanga', nom: 'Haut-Katanga', chefLieu: 'Lubumbashi', cibleAdos: 18000, quotaFilles: 50 },
    { id: 'nord_kivu', nom: 'Nord-Kivu', chefLieu: 'Goma', cibleAdos: 15000, quotaFilles: 51 },
    { id: 'sud_kivu', nom: 'Sud-Kivu', chefLieu: 'Bukavu', cibleAdos: 12000, quotaFilles: 50 },
    { id: 'kasai_oriental', nom: 'Kasaï-Oriental', chefLieu: 'Mbuji-Mayi', cibleAdos: 10000, quotaFilles: 50 },
    { id: 'tshopo', nom: 'Tshopo', chefLieu: 'Kisangani', cibleAdos: 9000, quotaFilles: 50 },
    { id: 'kongo_central', nom: 'Kongo-Central', chefLieu: 'Matadi', cibleAdos: 11000, quotaFilles: 50 }
  ],

  languages: [
    { code: 'fr', nom: 'Français', flag: '🇫🇷' },
    { code: 'ln', nom: 'Lingála', flag: '🇨🇩' },
    { code: 'sw', nom: 'Kiswahili', flag: '🇹🇿' },
    { code: 'tsh', nom: 'Tshiluba', flag: '🇨🇩' },
    { code: 'kg', nom: 'Kikongo', flag: '🇨🇩' }
  ],

  roles: [
    { id: 'ado', nom: 'Adolescent (12-17 ans)', description: 'Accès inscription, formation, badges, soumission contenus' },
    { id: 'encadreur', nom: 'Encadreur REIPE / Terrain', description: 'Validation inscriptions hors ligne, suivi proximité, validation niveau 1' },
    { id: 'ponabana', nom: 'Comité Éditorial Ponabana', description: 'Validation finale niveau 2, publication WordPress, calendrier éditorial' },
    { id: 'provincial', nom: 'Division Provinciale (Ministères)', description: 'Consultation désagrégée par province, délivrance des attestations' },
    { id: 'unicef_ca', nom: 'UNICEF Section C&A / PSE', description: 'Pilotage national, analyse équité, gestion des alertes sauvegarde' },
    { id: 'admin', nom: 'Administrateur Système', description: 'Gestion des rôles, journal d\'audit, gestion des contenus pédagogiques' }
  ],

  adolescents: [
    {
      id: 'UNICEF-RDC-784101',
      prenom: 'Amina',
      nomFamillePseudonymise: 'K***',
      age: 15,
      sexe: 'F',
      province: 'Kinshasa',
      ville: 'Kinshasa / Ndjili',
      milieu: 'urbain',
      statutScolaire: 'scolarise',
      handicap: 'aucun',
      langue: 'ln',
      telephone: '+243810012345',
      canalInscription: 'whatsapp',
      dateInscription: '2026-09-12',
      consentement: {
        statut: 'valide',
        mode: 'whatsapp',
        nomParent: 'Papa Kanku',
        dateValidation: '2026-09-13',
        telephoneParent: '+243990012345'
      },
      progression: {
        modulesTermines: [1, 2, 3, 4, 5, 6],
        scoreMoyen: 94,
        certifie: true,
        dateCertification: '2026-09-20',
        codeCertificat: 'CERT-2026-KIN-784101',
        filiere: 'enfant_reporter'
      },
      badges: ['premier_pas', 'droits_enfant', 'fact_checker', 'reporter_etoile'],
      statut: 'actif'
    },
    {
      id: 'UNICEF-RDC-784102',
      prenom: 'David',
      nomFamillePseudonymise: 'M***',
      age: 16,
      sexe: 'M',
      province: 'Haut-Katanga',
      ville: 'Lubumbashi / Kenya',
      milieu: 'urbain',
      statutScolaire: 'scolarise',
      handicap: 'aucun',
      langue: 'sw',
      telephone: '+243820054321',
      canalInscription: 'web',
      dateInscription: '2026-09-15',
      consentement: {
        statut: 'valide',
        mode: 'sms',
        nomParent: 'Maman Mwamba',
        dateValidation: '2026-09-16',
        telephoneParent: '+243970054321'
      },
      progression: {
        modulesTermines: [1, 2, 3, 4, 5, 6],
        scoreMoyen: 88,
        certifie: true,
        dateCertification: '2026-09-24',
        codeCertificat: 'CERT-2026-HK-784102',
        filiere: 'plaidoyer'
      },
      badges: ['premier_pas', 'droits_enfant', 'plaidoyer_leader'],
      statut: 'actif'
    },
    {
      id: 'UNICEF-RDC-784103',
      prenom: 'Dorcas',
      nomFamillePseudonymise: 'T***',
      age: 14,
      sexe: 'F',
      province: 'Nord-Kivu',
      ville: 'Goma',
      milieu: 'urbain',
      statutScolaire: 'scolarise',
      handicap: 'moteur',
      langue: 'sw',
      telephone: '+243890098765',
      canalInscription: 'assiste_reipe',
      dateInscription: '2026-09-18',
      consentement: {
        statut: 'valide',
        mode: 'papier',
        nomParent: 'Tuteur Bahati',
        dateValidation: '2026-09-19',
        telephoneParent: '+243990098765'
      },
      progression: {
        modulesTermines: [1, 2, 3],
        scoreMoyen: 90,
        certifie: false,
        dateCertification: null,
        codeCertificat: null,
        filiere: null
      },
      badges: ['premier_pas', 'droits_enfant'],
      statut: 'en_formation'
    },
    {
      id: 'UNICEF-RDC-784104',
      prenom: 'Gloire',
      nomFamillePseudonymise: 'B***',
      age: 17,
      sexe: 'M',
      province: 'Kasaï-Oriental',
      ville: 'Mbuji-Mayi / Dibindi',
      milieu: 'rural',
      statutScolaire: 'formation_pro',
      handicap: 'aucun',
      langue: 'tsh',
      telephone: '+243840011223',
      canalInscription: 'sms',
      dateInscription: '2026-09-21',
      consentement: {
        statut: 'en_attente',
        mode: 'sms',
        nomParent: 'Papa Bope',
        dateValidation: null,
        telephoneParent: '+243980011223'
      },
      progression: {
        modulesTermines: [1],
        scoreMoyen: 85,
        certifie: false,
        dateCertification: null,
        codeCertificat: null,
        filiere: null
      },
      badges: ['premier_pas'],
      statut: 'en_attente_consentement'
    },
    {
      id: 'UNICEF-RDC-784105',
      prenom: 'Espérance',
      nomFamillePseudonymise: 'N***',
      age: 13,
      sexe: 'F',
      province: 'Kongo-Central',
      ville: 'Matadi',
      milieu: 'urbain',
      statutScolaire: 'scolarise',
      handicap: 'aucun',
      langue: 'kg',
      telephone: '+243850022334',
      canalInscription: 'web',
      dateInscription: '2026-09-25',
      consentement: {
        statut: 'valide',
        mode: 'web',
        nomParent: 'Maman Nzuzi',
        dateValidation: '2026-09-25',
        telephoneParent: '+243900022334'
      },
      progression: {
        modulesTermines: [1, 2, 3, 4, 5, 6],
        scoreMoyen: 96,
        certifie: true,
        dateCertification: '2026-09-29',
        codeCertificat: 'CERT-2026-KC-784105',
        filiere: 'enfant_reporter'
      },
      badges: ['premier_pas', 'droits_enfant', 'fact_checker', 'reporter_etoile'],
      statut: 'actif'
    }
  ],

  trainingModules: [
    {
      id: 1,
      numero: 1,
      titre: 'Droits de l\'enfant & Cadre Légal en RDC',
      duree: '12 min',
      categorie: 'Fondamentaux',
      description: 'Découvrir la Convention relative aux droits de l\'enfant (CIDE) et la loi congolaise n° 09/001.',
      icon: 'ShieldCheck',
      badgeId: 'droits_enfant',
      badgeName: 'Défenseur des Droits',
      badgeColor: '#0284c7',
      objectifs: [
        'Comprendre les 4 principes directeurs de la CIDE (Non-discrimination, Intérêt supérieur, Droit à la vie et développement, Respect de l\'opinion)',
        'Connaître les droits fondamentaux protégés par la loi congolaise (éducation, santé, protection)',
        'Identifier les devoirs de l\'État, des communautés et des familles'
      ],
      contenuTexte: `La Convention relative aux droits de l'enfant (CIDE) est un traité international ratifié par la République Démocratique du Congo. Elle reconnaît que chaque être humain de moins de 18 ans a des droits spécifiques pour grandir en sécurité, être protégé contre toutes les formes de violence, avoir accès à une éducation de qualité et exprimer librement son opinion. En RDC, la loi du 10 janvier 2009 renforce cette protection juridique.`,
      capsuleAudio: 'audio-mod1-droits.mp3',
      videoTaille: '240p (8.4 Mo) - Compressé',
      quiz: [
        {
          id: 'q1_1',
          question: 'Quel est l\'âge limite d\'un enfant selon la Convention relative aux droits de l\'enfant ?',
          options: [
            { text: 'Moins de 15 ans', correct: false },
            { text: 'Moins de 18 ans', correct: true },
            { text: 'Moins de 21 ans', correct: false },
            { text: 'Moins de 12 ans', correct: false }
          ],
          explication: 'Selon la CIDE et la loi congolaise, est considéré comme enfant tout être humain âgé de moins de 18 ans.'
        },
        {
          id: 'q1_2',
          question: 'Lequel de ces principes est l\'un des 4 piliers majeurs de la CIDE ?',
          options: [
            { text: 'L\'obligation de travailler', correct: false },
            { text: 'L\'intérêt supérieur de l\'enfant', correct: true },
            { text: 'Le secret absolu envers les parents', correct: false },
            { text: 'L\'accès réservé aux garçons', correct: false }
          ],
          explication: 'L\'intérêt supérieur de l\'enfant doit être une considération primordiale dans toutes les décisions le concernant.'
        }
      ]
    },
    {
      id: 2,
      numero: 2,
      titre: 'Tactiques de Plaidoyer & Guide Pratique',
      duree: '15 min',
      categorie: 'Plaidoyer',
      description: 'Comment formuler un message percutant, identifier les décideurs clés et négocier des engagements.',
      icon: 'Megaphone',
      badgeId: 'plaidoyer_leader',
      badgeName: 'Artisan du Plaidoyer',
      badgeColor: '#f59e0b',
      objectifs: [
        'Définir le problème précis et la solution souhaitée (formule SMART)',
        'Cartographier les décideurs (députés, ministres, chefs traditionnels, bourgmestres)',
        'Préparer une note de plaidoyer respectueuse et étayée de preuves'
      ],
      contenuTexte: `Le plaidoyer mené par les adolescents consiste à porter la voix des pairs auprès des autorités publiques, des leaders communautaires et des décideurs afin d'obtenir des changements positifs durables dans les politiques, les budgets ou les pratiques quotidiennes.`,
      quiz: [
        {
          id: 'q2_1',
          question: 'Que signifie l\'acronyme SMART pour un objectif de plaidoyer ?',
          options: [
            { text: 'Spécifique, Mesurable, Atteignable, Réaliste, Temporellement défini', correct: true },
            { text: 'Secret, Militaire, Actif, Rapide, Total', correct: false },
            { text: 'Simple, Moyen, Aléatoire, Répété, Tardif', correct: false }
          ],
          explication: 'Un objectif SMART garantit la clarté et l\'efficacité de votre demande auprès des décideurs.'
        }
      ]
    },
    {
      id: 3,
      numero: 3,
      titre: 'Journalisme Citoyen & Enfant Reporter',
      duree: '14 min',
      categorie: 'Journalisme',
      description: 'Techniques d\'interview, structuration d\'un article, cadrage photo et narration éthique.',
      icon: 'Camera',
      badgeId: 'reporter_etoile',
      badgeName: 'Enfant Reporter Pro',
      badgeColor: '#10b981',
      objectifs: [
        'Appliquer la règle des 5W (Qui, Quoi, Où, Quand, Pourquoi)',
        'Mener une interview bienveillante et obtenir le consentement préalable',
        'Cadrer une photographie en respectant la dignité de la personne'
      ],
      contenuTexte: `Être enfant reporter, c'est raconter la réalité de sa communauté à travers le regard des enfants, en donnant la parole à ceux qu'on n'entend pas souvent, tout en respectant scrupuleusement l'éthique et la sécurité de chacun.`,
      quiz: [
        {
          id: 'q3_1',
          question: 'Que doit-on impérativement recueillir avant de photographier ou interviewer un enfant ?',
          options: [
            { text: 'Une autorisation payante', correct: false },
            { text: 'Le consentement libre et éclairé de l\'enfant et de son tuteur', correct: true },
            { text: 'Une signature de police', correct: false }
          ],
          explication: 'Le consentement parental et l\'accord volontaire de l\'enfant sont obligatoires et non négociables.'
        }
      ]
    },
    {
      id: 4,
      numero: 4,
      titre: 'Vérification des Faits (Fact-Checking)',
      duree: '10 min',
      categorie: 'Éducation aux médias',
      description: 'Lutter contre la désinformation, identifier les rumeurs et croiser les sources fiables.',
      icon: 'SearchCheck',
      badgeId: 'fact_checker',
      badgeName: 'Traqueur de Rumeurs',
      badgeColor: '#8b5cf6',
      objectifs: [
        'Distinguer un fait avéré d\'une opinion ou d\'une rumeur',
        'Effectuer une recherche inversée d\'image pour détecter les manipulations',
        'Consulter au moins deux sources indépendantes avant de partager'
      ],
      contenuTexte: `Dans un environnement numérique saturé d'informations, les rumeurs et fausses nouvelles (fake news) peuvent causer du tort. L'adolescent engagé apprend à vérifier la date, l'auteur, le contexte et la source originale de chaque information.`,
      quiz: [
        {
          id: 'q4_1',
          question: 'Quelle est la première action à entreprendre face à une vidéo sensationnelle sur WhatsApp ?',
          options: [
            { text: 'La transférer immédiatement à tous ses contacts', correct: false },
            { text: 'Vérifier la date, l\'origine et croiser avec des médias reconnus', correct: true },
            { text: 'La supprimer sans chercher à comprendre', correct: false }
          ],
          explication: 'Toujours marquer une pause et vérifier les faits avant tout partage.'
        }
      ]
    },
    {
      id: 5,
      numero: 5,
      titre: 'Sécurité Numérique & Vie Privée',
      duree: '12 min',
      categorie: 'Protection en ligne',
      description: 'Protéger ses données personnelles, éviter le cyberharcèlement et sécuriser ses comptes.',
      icon: 'Lock',
      badgeId: 'cyber_gardien',
      badgeName: 'Gardien du Net',
      badgeColor: '#ec4899',
      objectifs: [
        'Créer un mot de passe robuste et activer la double authentification',
        'Ne jamais partager d\'informations sensibles (adresse exacte, numéro d\'identité)',
        'Savoir réagir et signaler en cas de message suspect ou de harcèlement'
      ],
      contenuTexte: `Internet et les réseaux sociaux sont de formidables espaces d'expression mais comportent des pièges. Protéger son empreinte numérique et respecter la vie privée des autres est la première responsabilité de l'adolescent digital.`,
      quiz: [
        {
          id: 'q5_1',
          question: 'Un mot de passe sécurisé doit contenir :',
          options: [
            { text: 'Son prénom suivi de sa date de naissance', correct: false },
            { text: 'Au moins 12 caractères mêlant majuscules, minuscules, chiffres et symboles', correct: true },
            { text: '12345678', correct: false }
          ],
          explication: 'La complexité et la longueur du mot de passe protègent vos comptes contre les attaques automatiques.'
        }
      ]
    },
    {
      id: 6,
      numero: 6,
      titre: 'Éthique & Cadre Éditorial Ponabana',
      duree: '12 min',
      categorie: 'Édition & Sauvegarde',
      description: 'Ligne éditoriale du blog Ponabana, sauvegarde de l\'enfance, floutage et dignité.',
      icon: 'FileCheck',
      badgeId: 'ethique_unicef',
      badgeName: 'Ambassadeur Éthique',
      badgeColor: '#0ea5e9',
      objectifs: [
        'Respecter la charte éditoriale Ponabana de l\'UNICEF RDC',
        'Veiller à la non-revictimisation des enfants vulnérables',
        'Supprimer systématiquement les métadonnées géographiques de ses photos'
      ],
      contenuTexte: `Le blog Ponabana est la tribune officielle des enfants reporters de RDC. Chaque contenu publié doit respecter l'esprit de bienveillance, valoriser les solutions locales et préserver l'anonymat des enfants en situation de risque.`,
      quiz: [
        {
          id: 'q6_1',
          question: 'Lorsqu\'un article traite d\'un enfant victime d\'un abus, quelle est la règle stricte ?',
          options: [
            { text: 'Publier son nom complet pour alerter l\'opinion', correct: false },
            { text: 'Anonymiser obligatoirement, flouter le visage et protéger sa localisation', correct: true },
            { text: 'Indiquer l\'adresse de son école', correct: false }
          ],
          explication: 'La sauvegarde de l\'enfant prime toujours sur la visibilité médiatique.'
        }
      ]
    }
  ],

  reportersContents: [
    {
      id: 'CONT-2026-001',
      titre: 'Accès à l\'eau potable dans les écoles de Masina : le cri du cœur des élèves',
      theme: 'Eau, Assainissement et Hygiène (WASH)',
      format: 'article_photo',
      auteurId: 'UNICEF-RDC-784101',
      auteurPrenom: 'Amina',
      pseudonymeAttribution: 'Amina K. (15 ans, Kinshasa)',
      province: 'Kinshasa',
      lieu: 'Commune de Masina',
      dateSoumission: '2026-09-28',
      sources: 'Directeur de l\'EP 3 Masina, 3 délégués de classe',
      consentementMentionne: true,
      verificationFaitsDeclaree: true,
      faceBlurAlert: false,
      exifStripped: true,
      statut: 'publie_ponabana',
      validationEncadreur: {
        validePar: 'Jean-Pierre Malu (REIPE Masina)',
        date: '2026-09-29',
        commentaire: 'Article très bien structuré, sources vérifiées et ton respectueux.'
      },
      validationComite: {
        validePar: 'Rédaction Ponabana UNICEF RDC',
        date: '2026-09-30',
        commentaire: 'Validé pour publication avec mise en avant sur le portail national.'
      },
      ponabanaUrl: 'https://ponabana.org/2026/09/acces-eau-potable-ecoles-masina-amina/'
    },
    {
      id: 'CONT-2026-002',
      titre: 'Comment notre club de jeunes a réhabilité l\'espace de jeux communautaire',
      theme: 'Participation des jeunes et loisirs',
      format: 'photo_reportage',
      auteurId: 'UNICEF-RDC-784102',
      auteurPrenom: 'David',
      pseudonymeAttribution: 'David M. (16 ans, Lubumbashi)',
      province: 'Haut-Katanga',
      lieu: 'Quartier Kenya, Lubumbashi',
      dateSoumission: '2026-09-30',
      sources: 'Chef de quartier et membres du club REIPE',
      consentementMentionne: true,
      verificationFaitsDeclaree: true,
      faceBlurAlert: false,
      exifStripped: true,
      statut: 'valide_encadreur',
      validationEncadreur: {
        validePar: 'Carine Kabedi (REIPE Lubumbashi)',
        date: '2026-10-01',
        commentaire: 'Photos de grande qualité, respect de la dignité bien appliqué.'
      },
      validationComite: null,
      ponabanaUrl: null
    },
    {
      id: 'CONT-2026-003',
      titre: 'Témoignage : continuer l\'école malgré le déplacement forcé',
      theme: 'Éducation en situation d\'urgence',
      format: 'audio_capsule',
      auteurId: 'UNICEF-RDC-784105',
      auteurPrenom: 'Espérance',
      pseudonymeAttribution: 'Espérance (13 ans, anonymat partiel demandé)',
      province: 'Nord-Kivu',
      lieu: 'Camp de déplacement périphérie de Goma',
      dateSoumission: '2026-10-01',
      sources: 'Enseignants bénévoles du centre d\'apprentissage',
      consentementMentionne: true,
      verificationFaitsDeclaree: true,
      faceBlurAlert: true, // Visage détecté nécessitant floutage
      exifStripped: true,
      statut: 'en_attente_encadreur',
      validationEncadreur: null,
      validationComite: null,
      ponabanaUrl: null
    }
  ],

  advocacyCampaigns: [
    {
      id: 'CAMP-2026-01',
      titre: 'Zéro enfant sans acte de naissance à l\'école primaire',
      province: 'Kinshasa',
      cibleDecideurs: 'Bourgmestres et Officiers d\'état civil',
      adosParticipants: 42,
      statut: 'en_cours',
      engagementsObtenus: [
        'Organisation d\'une audience foraine d\'enregistrement gratuite en novembre 2026 par la commune de Kimbanseke.'
      ]
    },
    {
      id: 'CAMP-2026-02',
      titre: 'Sécurisation des traversées piétonnes devant les collèges de Lubumbashi',
      province: 'Haut-Katanga',
      cibleDecideurs: 'Mairie de Lubumbashi & Commission Nationale de Prévention Routière',
      adosParticipants: 28,
      statut: 'succes',
      engagementsObtenus: [
        'Pose de 4 ralentisseurs et panneaux de signalisation devant le Collège Imara validée au budget communal.'
      ]
    }
  ],

  safeguardIncidents: [
    {
      id: 'SAFE-2026-001',
      dateSignalement: '2026-09-27 14:32',
      type: 'Tentative de contact inapproprié en ligne',
      severite: 'haute',
      province: 'Kinshasa',
      statut: 'en_cours_investigation',
      pointFocalUnicef: 'Mme Chantal Mukendi (PSE UNICEF)',
      delaiReponseHeures: 4,
      actionsEntreprises: 'Compte suspect bloqué, entretien de soutien psychologique mené avec le tuteur légal.'
    }
  ],

  auditLogs: [
    {
      id: 'LOG-1001',
      horodatage: '2026-10-01 09:15',
      utilisateur: 'Admin REIPE Kinshasa',
      role: 'encadreur',
      action: 'Validation inscription assistée (lot #4)',
      details: '12 dossiers synchronisés depuis Masina'
    },
    {
      id: 'LOG-1002',
      horodatage: '2026-10-01 11:30',
      utilisateur: 'Équipe C&A UNICEF',
      role: 'unicef_ca',
      action: 'Export statistiques désagrégées',
      details: 'Export CSV consolidé Q3-2026'
    }
  ]
}
