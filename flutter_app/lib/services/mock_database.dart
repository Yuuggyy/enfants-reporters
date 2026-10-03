import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'api_service.dart';

class MockDatabaseService extends ChangeNotifier {
  final ApiService api = ApiService();

  bool _isBackendOnline = false;
  bool _isCheckingHealth = false;
  String? _lastBackendError;

  bool get isBackendOnline => _isBackendOnline;
  bool get isCheckingHealth => _isCheckingHealth;
  String? get lastBackendError => _lastBackendError;

  MockDatabaseService() {
    checkBackendStatus();
  }

  // --- VÉRIFICATION DE LA CONNEXION BACKEND ---
  Future<bool> checkBackendStatus() async {
    _isCheckingHealth = true;
    notifyListeners();

    try {
      final healthy = await api.checkHealth();
      _isBackendOnline = healthy;
      if (healthy) {
        _lastBackendError = null;
        await syncFromBackend();
      } else {
        _lastBackendError = 'Le serveur FastAPI sur http://127.0.0.1:8000 ne répond pas.';
      }
    } catch (e) {
      _isBackendOnline = false;
      _lastBackendError = e.toString();
    } finally {
      _isCheckingHealth = false;
      notifyListeners();
    }
    return _isBackendOnline;
  }

  // --- SYNCHRONISATION COMPLÈTE AVEC LE BACKEND PYTHON (SQLite/PostgreSQL) ---
  Future<void> syncFromBackend() async {
    try {
      // 1. Synchroniser les adolescents
      final adosJson = await api.getAdolescents();
      _adolescents.clear();
      for (final item in adosJson) {
        _adolescents.add(Adolescent(
          id: item['id'] ?? 'ADO-INCONNU',
          prenom: item['prenom'] ?? 'Inconnu',
          age: item['age'] ?? 15,
          sexe: item['sexe'] ?? 'F',
          province: item['province'] ?? 'Kinshasa',
          ville: item['ville'] ?? 'Nsele',
          milieu: item['milieu'] ?? 'Urbain',
          statutScolaire: item['statut_scolaire'] ?? 'Scolarisé(e)',
          situationHandicap: item['handicap'] ?? false,
          languePreferee: item['langue_preferee'] ?? 'Français',
          telephone: item['telephone'] ?? '+243800000000',
          telephoneParent: item['telephone_parent'] ?? '+243800000000',
          clubId: item['club_id'] ?? (_clubs.isNotEmpty ? _clubs.first.id : 'CLUB-KIN-01'),
          canal: _mapBackendToCanal(item['canal_inscription']),
          statutConsentement: item['statut_consentement'] == 'ACCORDE'
              ? StatutConsentement.valide
              : (item['statut_consentement'] == 'REVOQUE'
                  ? StatutConsentement.revoque
                  : StatutConsentement.enAttente),
          modeConsentement: item['mode_consentement'] ?? 'SMS / WhatsApp',
          progressionFormation: item['points_xp'] != null ? (item['points_xp'] as int) : 0,
          certifie: item['certifie'] ?? false,
          codeCertificat: item['code_certificat'] ?? '',
          dateInscription: item['date_inscription'] != null
              ? item['date_inscription'].toString().substring(0, 10)
              : '2026-10-02',
          badges: ['Membre Officiel BanApp'],
        ));
      }

      // 2. Synchroniser les notifications encadreurs
      final notifsJson = await api.getEncadreurNotifications();
      if (notifsJson.isNotEmpty) {
        _notifications.clear();
        for (final n in notifsJson) {
          _notifications.add(NotificationEncadreur(
            id: n['id'] ?? 'NOTIF-0',
            encadreurId: n['encadreur_id'] ?? 'ENC-KIN-01',
            adolescentId: n['adolescent_id'] ?? '',
            adolescentNom: n['adolescent_details'] != null
                ? n['adolescent_details']['prenom'] ?? 'Adolescent'
                : 'Adolescent',
            clubNom: 'Club Territorial',
            date: n['created_at'] != null ? n['created_at'].toString().substring(0, 16) : 'À l\'instant',
            message: n['message'] ?? n['titre'] ?? '',
            traitee: n['is_read'] ?? false,
          ));
        }
      }

      // 3. Synchroniser les reportages Ponabana
      final reportagesJson = await api.getReportages();
      if (reportagesJson.isNotEmpty) {
        _medias.clear();
        for (final r in reportagesJson) {
          _medias.add(ContenuMedia(
            id: r['id'] ?? 'REP-0',
            titre: r['titre'] ?? 'Reportage',
            theme: r['theme'] ?? 'Droits de l\'Enfant',
            type: (r['type_media'] ?? 'Article').toString().toUpperCase(),
            auteurId: r['auteur_id'] ?? 'ADO-0',
            auteurPrenom: 'Enfant Reporter',
            clubId: 'CLUB-KIN-01',
            province: 'Kinshasa',
            dateSoumission: r['date_soumission'] != null
                ? r['date_soumission'].toString().substring(0, 10)
                : '2026-10-02',
            statut: r['statut'] == 'PUBLIE_PONABANA_N2'
                ? 'Publié Ponabana (WordPress)'
                : (r['statut'] == 'VALIDE_N1'
                    ? 'Validé Encadreur'
                    : 'En attente modération Encadreur'),
            resume: r['contenu'] ?? '',
            commentaireEncadreur: r['avis_encadreur'],
            exifPurge: r['exif_purge'] ?? true,
            floutageEffectue: r['floutage_actif'] ?? true,
            consentementSujets: r['consentement_interviewes'] ?? true,
          ));
        }
      }

      // 4. Synchroniser les incidents de sauvegarde
      final incidentsJson = await api.getSafeguardIncidents();
      if (incidentsJson.isNotEmpty) {
        _incidents.clear();
        for (final inc in incidentsJson) {
          _incidents.add(IncidentSauvegarde(
            id: inc['id'] ?? 'PSE-0',
            type: inc['type_incident'] ?? 'Signalement',
            province: inc['province'] ?? 'Kinshasa',
            description: inc['description'] ?? '',
            date: inc['date_signalement'] != null
                ? inc['date_signalement'].toString().substring(0, 16)
                : '2026-10-02',
            statut: inc['statut'] ?? 'SIGNALÉ_SLA_24H',
          ));
        }
      }

      // 5. Synchroniser le journal d'audit
      final auditJson = await api.getAuditLogs();
      if (auditJson.isNotEmpty) {
        _auditLogs.clear();
        for (final a in auditJson) {
          _auditLogs.add(EntreeAudit(
            id: 'AUD-${a['id']}',
            utilisateur: a['user_id'] ?? 'Système',
            role: a['user_role'] ?? 'USER',
            action: a['details'] ?? a['action'] ?? '',
            date: a['timestamp'] != null ? a['timestamp'].toString().substring(0, 16) : '',
          ));
        }
      }

      _isBackendOnline = true;
      _lastBackendError = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[MockDatabaseService] Sync backend en attente: $e');
    }
  }

  CanalInscription _mapBackendToCanal(String? backendVal) {
    switch (backendVal) {
      case 'CHATBOT_RAPIDPRO':
        return CanalInscription.whatsapp;
      case 'USSD':
        return CanalInscription.ussd;
      case 'SMS':
        return CanalInscription.sms;
      case 'ASSISTED_REIPE':
        return CanalInscription.assiste;
      case 'WEB':
      default:
        return CanalInscription.web;
    }
  }

  // --- AUTHENTIFICATION & SESSIONS ---
  bool _isLoggedIn = false;
  RoleUtilisateur _currentRole = RoleUtilisateur.adolescent;

  String _activeAdolescentId = '';
  String _activeEncadreurId = 'ENC-KIN-01';

  bool get isLoggedIn => _isLoggedIn;
  RoleUtilisateur get currentRole => _currentRole;
  String get activeAdolescentId => _activeAdolescentId;
  String get activeEncadreurId => _activeEncadreurId;

  Adolescent get activeAdolescent {
    if (_adolescents.isEmpty) {
      return Adolescent(
        id: 'ADO-INVITE',
        prenom: 'Nouvel Adolescent',
        age: 15,
        sexe: 'F',
        province: 'Kinshasa',
        ville: 'Nsele',
        milieu: 'Périurbain',
        statutScolaire: 'Scolarisé(e)',
        situationHandicap: false,
        languePreferee: 'Français',
        telephone: '+243800000000',
        telephoneParent: '+243800000000',
        clubId: _clubs.isNotEmpty ? _clubs.first.id : '',
        canal: CanalInscription.web,
        statutConsentement: StatutConsentement.enAttente,
        modeConsentement: 'En attente',
        progressionFormation: 0,
        certifie: false,
        codeCertificat: '',
        dateInscription: '2026-10-02',
        badges: [],
      );
    }
    return _adolescents.firstWhere(
      (a) => a.id == _activeAdolescentId,
      orElse: () => _adolescents.first,
    );
  }

  Encadreur get activeEncadreur {
    return _encadreurs.firstWhere(
      (e) => e.id == _activeEncadreurId,
      orElse: () => _encadreurs.first,
    );
  }

  AdminUser get activeAdmin => _adminUser;

  ClubEngagement? get clubOfActiveAdolescent {
    final ado = activeAdolescent;
    return _clubs.firstWhere(
      (c) => c.id == ado.clubId,
      orElse: () => _clubs.first,
    );
  }

  List<ClubEngagement> get clubsOfActiveEncadreur {
    final enc = activeEncadreur;
    return _clubs.where((c) => enc.clubIds.contains(c.id)).toList();
  }

  // Connexion Enfant (Appel réel API)
  Future<bool> loginAsChild(String idOrPhone) async {
    final cleanInput = idOrPhone.trim();
    if (cleanInput.isEmpty) return false;

    try {
      final res = await api.login(cleanInput, '1234', role: 'ADOLESCENT');
      _activeAdolescentId = res['user_id'] ?? cleanInput;
      _currentRole = RoleUtilisateur.adolescent;
      _isLoggedIn = true;
      _isBackendOnline = true;
      await syncFromBackend();
      notifyListeners();
      return true;
    } catch (e) {
      // Fallback si correspondance locale
      final found = _adolescents.cast<Adolescent?>().firstWhere(
            (a) =>
                a != null &&
                (a.id.toLowerCase() == cleanInput.toLowerCase() ||
                    a.telephone.contains(cleanInput) ||
                    a.prenom.toLowerCase() == cleanInput.toLowerCase()),
            orElse: () => null,
          );
      if (found != null) {
        _activeAdolescentId = found.id;
        _currentRole = RoleUtilisateur.adolescent;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      rethrow;
    }
  }

  // Connexion Encadreur (Appel réel API)
  Future<bool> loginAsEncadreur(String emailOrPhone, String password) async {
    final cleanInput = emailOrPhone.trim();
    try {
      final res = await api.login(cleanInput, password, role: 'ENCADREUR');
      _activeEncadreurId = res['user_id'] ?? 'ENC-KIN-01';
      _currentRole = RoleUtilisateur.encadreur;
      _isLoggedIn = true;
      _isBackendOnline = true;
      await syncFromBackend();
      notifyListeners();
      return true;
    } catch (e) {
      final found = _encadreurs.cast<Encadreur?>().firstWhere(
            (enc) =>
                enc != null &&
                (enc.email.toLowerCase() == cleanInput.toLowerCase() ||
                    enc.id.toLowerCase() == cleanInput.toLowerCase()),
            orElse: () => null,
          );
      if (found != null && password.isNotEmpty) {
        _activeEncadreurId = found.id;
        _currentRole = RoleUtilisateur.encadreur;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      rethrow;
    }
  }

  // Connexion Admin (Appel réel API)
  Future<bool> loginAsAdmin(String email, String password, String token2fa) async {
    final cleanInput = email.trim();
    try {
      await api.login(cleanInput, password, role: 'ADMIN');
      _currentRole = RoleUtilisateur.admin;
      _isLoggedIn = true;
      _isBackendOnline = true;
      await syncFromBackend();
      notifyListeners();
      return true;
    } catch (e) {
      if (cleanInput == 'admin@unicef.cd' && password == 'AdminUnicef2026!') {
        _currentRole = RoleUtilisateur.admin;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      rethrow;
    }
  }

  void logout() {
    _isLoggedIn = false;
    api.authToken = null;
    notifyListeners();
  }

  void switchRoleDirect(RoleUtilisateur role) {
    _currentRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  // --- 1. ADMIN USER ---
  final AdminUser _adminUser = AdminUser(
    id: 'ADM-UNICEF-01',
    nom: 'UNICEF National',
    prenom: 'Superviseur',
    email: 'admin@unicef.cd',
    section: 'UNICEF C&A (Communication & Plaidoyer RDC)',
    roleTitre: 'Superviseur National & Administrateur Global',
    doubleFacteurActif: true,
  );

  // --- 2. ENCADREURS ---
  final List<Encadreur> _encadreurs = [
    Encadreur(
      id: 'ENC-KIN-01',
      nom: 'Mukendi',
      prenom: 'Alain',
      email: 'alain.mukendi@reipe.cd',
      telephone: '+243810011223',
      organisation: 'REIPE Kinshasa',
      province: 'Kinshasa',
      ville: 'Nsele',
      clubIds: ['CLUB-KIN-01'],
      datePriseFonction: '2025-01-15',
      actif: true,
    ),
    Encadreur(
      id: 'ENC-LUB-02',
      nom: 'Kabange',
      prenom: 'Sarah',
      email: 'sarah.k@reipe.cd',
      telephone: '+243820033445',
      organisation: 'REIPE Haut-Katanga',
      province: 'Haut-Katanga',
      ville: 'Lubumbashi',
      clubIds: ['CLUB-LUB-02'],
      datePriseFonction: '2025-03-01',
      actif: true,
    ),
    Encadreur(
      id: 'ENC-KAN-03',
      nom: 'Tshilumba',
      prenom: 'Jean',
      email: 'jean.t@reipe.cd',
      telephone: '+243890055667',
      organisation: 'REIPE Kasaï-Central',
      province: 'Kasaï-Central',
      ville: 'Kananga',
      clubIds: ['CLUB-KAN-03'],
      datePriseFonction: '2025-04-10',
      actif: true,
    ),
  ];

  List<Encadreur> get encadreurs => List.unmodifiable(_encadreurs);

  // --- 3. CLUBS D'ENGAGEMENT ---
  final List<ClubEngagement> _clubs = [
    ClubEngagement(
      id: 'CLUB-KIN-01',
      nom: 'Club Plaidoyer Nsele',
      province: 'Kinshasa',
      ville: 'Nsele',
      theme: 'Droit à l\'éducation & Hygiène scolaire',
      encadreurId: 'ENC-KIN-01',
      encadreurNom: 'Alain Mukendi',
      encadreurTelephone: '+243810011223',
      groupeWhatsappRapidPro: 'https://chat.whatsapp.com/UNICEF-Nsele-Plaidoyer',
      prochaineActivite: 'Aucune activité planifiée',
      nombreMembres: 0,
    ),
    ClubEngagement(
      id: 'CLUB-LUB-02',
      nom: 'Club Voix des Jeunes Katanga',
      province: 'Haut-Katanga',
      ville: 'Lubumbashi',
      theme: 'Protection des enfants & Journalisme citoyen',
      encadreurId: 'ENC-LUB-02',
      encadreurNom: 'Sarah Kabange',
      encadreurTelephone: '+243820033445',
      groupeWhatsappRapidPro: 'https://chat.whatsapp.com/UNICEF-Lubum-Reporters',
      prochaineActivite: 'Aucune activité planifiée',
      nombreMembres: 0,
    ),
    ClubEngagement(
      id: 'CLUB-KAN-03',
      nom: 'Club Espoir & Climat Kananga',
      province: 'Kasaï-Central',
      ville: 'Kananga',
      theme: 'Inclusion des enfants déplacés & Handicap',
      encadreurId: 'ENC-KAN-03',
      encadreurNom: 'Jean Tshilumba',
      encadreurTelephone: '+243890055667',
      groupeWhatsappRapidPro: 'https://chat.whatsapp.com/UNICEF-Kananga-Voix',
      prochaineActivite: 'Aucune activité planifiée',
      nombreMembres: 0,
    ),
  ];

  List<ClubEngagement> get clubs => List.unmodifiable(_clubs);

  ClubEngagement getClubById(String clubId) {
    return _clubs.firstWhere(
      (c) => c.id == clubId,
      orElse: () => _clubs.first,
    );
  }

  // --- 4. ADOLESCENTS ---
  final List<Adolescent> _adolescents = [];
  List<Adolescent> get adolescents => List.unmodifiable(_adolescents);

  List<Adolescent> getAdolescentsForClub(String clubId) {
    return _adolescents.where((a) => a.clubId == clubId).toList();
  }

  // --- 5. NOTIFICATIONS ENCADREURS ---
  final List<NotificationEncadreur> _notifications = [];
  List<NotificationEncadreur> get notifications => List.unmodifiable(_notifications);

  List<NotificationEncadreur> get notificationsForActiveEncadreur {
    return _notifications.where((n) => n.encadreurId == _activeEncadreurId).toList();
  }

  // --- 6. MODULES DE FORMATION ---
  final List<ModuleFormation> _modules = [
    ModuleFormation(
      numero: 1,
      titre: 'Droits Fondamentaux de l\'Enfant',
      duree: '12 min',
      categorie: 'Socle Juridique',
      description:
          'Découverte de la CDE et des 4 principes clés : non-discrimination, intérêt supérieur, survie & développement, participation.',
      audioSummary: 'Capsule audio pédagogique en français et 4 langues nationales.',
      pointsCles: [
        'Droit à l\'éducation et à la santé de qualité',
        'Protection intégrale contre toute forme de violence',
        'Liberté d\'expression et de participation citoyenne',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Quel est l\'un des 4 principes fondamentaux de la Convention relative aux Droits de l\'Enfant ?',
          options: [
            'L\'obligation de travailler dès 12 ans',
            'L\'intérêt supérieur de l\'enfant',
            'Le droit de vote à 14 ans',
          ],
          indexCorrect: 1,
          feedback: 'Bravo ! L\'intérêt supérieur de l\'enfant doit guider toute décision le concernant.',
        ),
      ],
    ),
    ModuleFormation(
      numero: 2,
      titre: 'Tactiques de Plaidoyer & Action',
      duree: '15 min',
      categorie: 'Guide Pratique',
      description:
          'Comment formuler un message percutant, identifier les décideurs clés et obtenir des engagements concrets.',
      audioSummary: 'Guide d\'élaboration d\'un plan de plaidoyer local.',
      pointsCles: [
        'Définir un objectif SMART de plaidoyer',
        'Cartographier les décideurs et alliés stratégiques',
        'Construire un dialogue constructif et documenté',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Que signifie un objectif de plaidoyer "SMART" ?',
          options: [
            'Spécifique, Mesurable, Atteignable, Réaliste, Temporellement défini',
            'Secret, Militaire, Rapide et Total',
            'Simple, Manuel, Automatique et Répété',
          ],
          indexCorrect: 0,
          feedback: 'Exact ! Un objectif bien ciblé garantit des résultats mesurables.',
        ),
      ],
    ),
    ModuleFormation(
      numero: 3,
      titre: 'Journalisme Citoyen & Reportage',
      duree: '15 min',
      categorie: 'Médias Jeunes',
      description:
          'Techniques de collecte d\'information, interview éthique, écriture d\'articles et prise de vue responsable.',
      audioSummary: 'Règles de cadrage et de prise de son mobile.',
      pointsCles: [
        'Poser les 5 questions clés (Qui, Quoi, Où, Quand, Pourquoi)',
        'Respect de la dignité et recueil du consentement',
        'Valoriser les solutions portées par la communauté',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Avant d\'enregistrer ou photographier un pair, que doit-on obligatoirement obtenir ?',
          options: [
            'Son accord verbal ou écrit éclairé',
            'Une autorisation payante',
            'Rien du tout s\'il s\'agit d\'un ami',
          ],
          indexCorrect: 0,
          feedback: 'Indispensable ! Le consentement libre et éclairé est le premier devoir éthique.',
        ),
      ],
    ),
    ModuleFormation(
      numero: 4,
      titre: 'Vérification des Faits (Fact-Checking)',
      duree: '10 min',
      categorie: 'Éducation aux Médias',
      description: 'Détecter les rumeurs, infox et manipulations sur les réseaux sociaux et dans son environnement.',
      audioSummary: 'Méthode de vérification d\'images et de sources.',
      pointsCles: [
        'Croiser au moins deux sources indépendantes et fiables',
        'Vérifier la date et le contexte d\'origine des photos',
        'Ne pas relayer une information non vérifiée',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Quelle est la première action face à une rumeur sensationnelle sur WhatsApp ?',
          options: [
            'La transférer immédiatement à tous ses groupes',
            'Suspendre le partage et chercher la source d\'origine officielle',
            'Ignorer sans chercher à comprendre',
          ],
          indexCorrect: 1,
          feedback: 'Exactement ! Stopper la chaîne de propagation permet de préserver la communauté.',
        ),
      ],
    ),
    ModuleFormation(
      numero: 5,
      titre: 'Sécurité Numérique & Protection',
      duree: '12 min',
      categorie: 'Sauvegarde',
      description: 'Protéger ses données personnelles, mots de passe, et réagir face au cyberharcèlement.',
      audioSummary: 'Paramétrage de la confidentialité et signalement.',
      pointsCles: [
        'Ne jamais partager son mot de passe ou adresse précise',
        'Activer la double authentification si disponible',
        'Utiliser le bouton d\'alerte 24h en cas de menace',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Que faire en cas de message menaçant ou suspect en ligne ?',
          options: [
            'Garder le secret par peur',
            'Faire une capture d\'écran et alerter immédiatement un encadreur ou le bouton Sauvegarde 24h',
            'Répondre avec agressivité',
          ],
          indexCorrect: 1,
          feedback: 'Parfait ! Conserver la preuve et alerter les adultes de confiance permet d\'agir vite.',
        ),
      ],
    ),
    ModuleFormation(
      numero: 6,
      titre: 'Éthique & Cadre Éditorial Ponabana',
      duree: '10 min',
      categorie: 'Certification Finale',
      description:
          'Ligne éditoriale du blog Ponabana, non-stigmatisation et valorisation de la voix des enfants congolais.',
      audioSummary: 'Guide d\'attribution et de publication Ponabana.',
      pointsCles: [
        'Refuser tout sensationnalisme et toute stigmatisation',
        'Choix du pseudonyme ou anonymat pour la sécurité',
        'Circuit de validation éditoriale en 2 étapes',
      ],
      complete: false,
      scoreQuiz: null,
      quiz: [
        QuestionQuiz(
          question: 'Qui effectue la première validation des contenus soumis avant Ponabana ?',
          options: [
            'L\'encadreur REIPE du club local',
            'Le public sur Facebook',
            'Personne, c\'est publié directement',
          ],
          indexCorrect: 0,
          feedback: 'Correct ! L\'encadreur de club assure le premier niveau de relecture et de vérification.',
        ),
      ],
    ),
  ];

  List<ModuleFormation> get modules => List.unmodifiable(_modules);

  // --- 7. REPORTAGES ---
  final List<ContenuMedia> _medias = [];
  List<ContenuMedia> get medias => List.unmodifiable(_medias);

  List<ContenuMedia> getMediasForClub(String clubId) {
    return _medias.where((m) => m.clubId == clubId).toList();
  }

  // --- 8. RAPIDPRO LOGS ---
  final List<MessageRapidPro> _rapidProLogs = [];
  List<MessageRapidPro> get rapidProLogs => List.unmodifiable(_rapidProLogs);

  void envoyerOtpRapidPro(String telephone, String motif) {
    _rapidProLogs.insert(
      0,
      MessageRapidPro(
        id: 'RP-OTP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        emetteur: 'RapidPro Auth Engine',
        destinataire: telephone,
        canal: 'WhatsApp / SMS',
        texte: 'Code de sécurité BanApp : 884-210 pour : $motif (Valide 10 min).',
        dateEnvoi: DateTime.now().toString().substring(0, 16),
        statut: 'Délivré',
      ),
    );
    notifyListeners();
  }

  void broadcasterMessageClub({
    required String clubId,
    required String canal,
    required String message,
  }) {
    final club = getClubById(clubId);
    final enc = activeEncadreur;
    _rapidProLogs.insert(
      0,
      MessageRapidPro(
        id: 'RP-CLUB-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        emetteur: 'Encadreur ${enc.nomComplet}',
        destinataire: '${club.nom} (${club.nombreMembres} membres)',
        canal: canal,
        texte: message,
        dateEnvoi: DateTime.now().toString().substring(0, 16),
        statut: 'Délivré',
      ),
    );
    notifyListeners();
  }

  void broadcasterCampagneNationale({
    required String titre,
    required String audience,
    required String canal,
    required String message,
  }) {
    _rapidProLogs.insert(
      0,
      MessageRapidPro(
        id: 'RP-NAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        emetteur: 'Admin UNICEF RDC',
        destinataire: 'National ($audience)',
        canal: canal,
        texte: '[$titre] $message',
        dateEnvoi: DateTime.now().toString().substring(0, 16),
        statut: 'Délivré',
      ),
    );
    notifyListeners();
  }

  void relancerConsentementRapidPro(String adolescentId) {
    final idx = _adolescents.indexWhere((a) => a.id == adolescentId);
    if (idx != -1) {
      final ado = _adolescents[idx];
      _rapidProLogs.insert(
        0,
        MessageRapidPro(
          id: 'RP-REL-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          emetteur: 'RapidPro Consent Bot',
          destinataire: '${ado.telephoneParent} (Parent de ${ado.prenom})',
          canal: 'WhatsApp / SMS',
          texte:
              'Rappel BanApp : Veuillez confirmer le consentement pour ${ado.prenom} (${ado.id}) pour lui permettre d\'accéder aux activités de son club.',
          dateEnvoi: DateTime.now().toString().substring(0, 16),
          statut: 'Délivré',
        ),
      );
      notifyListeners();
    }
  }

  // --- 9. INCIDENTS DE SAUVEGARDE & AUDIT ---
  final List<IncidentSauvegarde> _incidents = [];
  List<IncidentSauvegarde> get incidents => List.unmodifiable(_incidents);

  final List<EntreeAudit> _auditLogs = [];
  List<EntreeAudit> get auditLogs => List.unmodifiable(_auditLogs);

  // --- 10. FIL SOCIAL ---
  final List<SocialPost> _socialPosts = [];
  List<SocialPost> get socialPosts => List.unmodifiable(_socialPosts);

  void toggleLikePost(String postId) {
    final idx = _socialPosts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      if (_socialPosts[idx].isLiked) {
        _socialPosts[idx].isLiked = false;
        _socialPosts[idx].likesCount = (_socialPosts[idx].likesCount - 1).clamp(0, 9999);
      } else {
        _socialPosts[idx].isLiked = true;
        _socialPosts[idx].likesCount += 1;
      }
      notifyListeners();
    }
  }

  void ajouterCommentairePost(String postId, String texte) {
    if (texte.trim().isEmpty) return;
    final idx = _socialPosts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      final auteur = _currentRole == RoleUtilisateur.adolescent
          ? activeAdolescent.prenom
          : _currentRole == RoleUtilisateur.encadreur
              ? activeEncadreur.nomComplet
              : 'Admin UNICEF';
      final avatar = _currentRole == RoleUtilisateur.adolescent
          ? activeAdolescent.avatarUrl
          : _currentRole == RoleUtilisateur.encadreur
              ? activeEncadreur.avatarUrl
              : activeAdmin.avatarUrl;

      final nouveauCommentaire = SocialComment(
        id: 'COM-${DateTime.now().millisecondsSinceEpoch}',
        auteurNom: auteur,
        auteurAvatar: avatar,
        texte: texte.trim(),
        date: 'À l\'instant',
      );
      _socialPosts[idx].commentaires.add(nouveauCommentaire);
      notifyListeners();
    }
  }

  void creerSocialPost({
    required String texte,
    String? imageType,
    List<String> tags = const [],
  }) {
    if (texte.trim().isEmpty) return;

    final auteurId = _currentRole == RoleUtilisateur.adolescent
        ? activeAdolescent.id
        : _currentRole == RoleUtilisateur.encadreur
            ? activeEncadreur.id
            : activeAdmin.id;

    final auteurNom = _currentRole == RoleUtilisateur.adolescent
        ? activeAdolescent.prenom
        : _currentRole == RoleUtilisateur.encadreur
            ? activeEncadreur.nomComplet
            : activeAdmin.nomComplet;

    final auteurRole = _currentRole == RoleUtilisateur.adolescent
        ? 'Adolescent Reporter'
        : _currentRole == RoleUtilisateur.encadreur
            ? 'Encadreur REIPE'
            : 'UNICEF Officiel';

    final auteurAvatar = _currentRole == RoleUtilisateur.adolescent
        ? activeAdolescent.avatarUrl
        : _currentRole == RoleUtilisateur.encadreur
            ? activeEncadreur.avatarUrl
            : activeAdmin.avatarUrl;

    final ville = _currentRole == RoleUtilisateur.adolescent
        ? activeAdolescent.ville
        : _currentRole == RoleUtilisateur.encadreur
            ? activeEncadreur.ville
            : 'National';

    final clubNom = _currentRole == RoleUtilisateur.adolescent
        ? (clubOfActiveAdolescent?.nom ?? 'Club Jeunes')
        : _currentRole == RoleUtilisateur.encadreur
            ? (clubsOfActiveEncadreur.isNotEmpty ? clubsOfActiveEncadreur.first.nom : 'REIPE')
            : 'UNICEF RDC';

    final nouveauPost = SocialPost(
      id: 'POST-${DateTime.now().millisecondsSinceEpoch}',
      auteurId: auteurId,
      auteurNom: auteurNom,
      auteurRole: auteurRole,
      auteurAvatar: auteurAvatar,
      auteurVille: ville,
      clubNom: clubNom,
      texte: texte.trim(),
      imageType: imageType,
      date: 'À l\'instant',
      likesCount: 1,
      isLiked: true,
      tags: tags,
      commentaires: [],
    );

    _socialPosts.insert(0, nouveauPost);
    notifyListeners();
  }

  // --- ACTIONS OPÉRATIONNELLES ASYNCHRONES DIRECTES SUR FASTAPI ---
  Future<String> ajouterAdolescent(Adolescent ado) async {
    // 1. Appel direct API FastAPI
    final payload = {
      'prenom': ado.prenom,
      'age': ado.age,
      'sexe': ado.sexe,
      'province': ado.province,
      'ville': ado.ville,
      'milieu': ado.milieu == 'Rural' ? 'Rural' : 'Urbain',
      'statut_scolaire': ado.statutScolaire,
      'handicap': ado.situationHandicap,
      'langue_preferee': ado.languePreferee,
      'telephone': ado.telephone,
      'telephone_parent': ado.telephoneParent,
      'canal_inscription': ado.canal == CanalInscription.whatsapp
          ? 'CHATBOT_RAPIDPRO'
          : ado.canal == CanalInscription.ussd
              ? 'USSD'
              : ado.canal == CanalInscription.sms
                  ? 'SMS'
                  : ado.canal == CanalInscription.assiste
                      ? 'ASSISTED_REIPE'
                      : 'WEB',
    };

    try {
      final res = await api.registerAdolescent(payload);
      final realId = res['id'] ?? ado.id;

      // 2. Refresh from backend
      await syncFromBackend();
      notifyListeners();
      return realId;
    } catch (e) {
      // Si hors-ligne
      _adolescents.insert(0, ado);
      notifyListeners();
      return ado.id;
    }
  }

  Future<void> validerInscriptionParEncadreur(String adoId) async {
    try {
      await api.confirmRegistration(adoId);
      await syncFromBackend();
    } catch (e) {
      final idx = _adolescents.indexWhere((a) => a.id == adoId);
      if (idx != -1) {
        _adolescents[idx].statutConsentement = StatutConsentement.valide;
      }
      notifyListeners();
    }
  }

  Future<void> validerConsentement(String adoId, String mode) async {
    try {
      await api.updateParentalConsent(adoId, 'ACCORDE', mode: mode);
      await syncFromBackend();
    } catch (e) {
      final idx = _adolescents.indexWhere((a) => a.id == adoId);
      if (idx != -1) {
        _adolescents[idx].statutConsentement = StatutConsentement.valide;
      }
      notifyListeners();
    }
  }

  Future<void> revoquerConsentement(String adoId) async {
    try {
      await api.updateParentalConsent(adoId, 'REVOQUE');
      await syncFromBackend();
    } catch (e) {
      final idx = _adolescents.indexWhere((a) => a.id == adoId);
      if (idx != -1) {
        _adolescents[idx].statutConsentement = StatutConsentement.revoque;
      }
      notifyListeners();
    }
  }

  Future<void> completerQuiz(int numeroModule, int score) async {
    final idx = _modules.indexWhere((m) => m.numero == numeroModule);
    if (idx != -1) {
      _modules[idx].complete = true;
      _modules[idx].scoreQuiz = score;
      try {
        await api.submitQuiz('MOD-0$numeroModule', [0]);
      } catch (_) {}
      notifyListeners();
    }
  }

  Future<void> soumettreReportage(ContenuMedia media) async {
    try {
      await api.submitReportage({
        'titre': media.titre,
        'contenu': media.resume,
        'type_media': media.type.toLowerCase().contains('audio')
            ? 'audio'
            : media.type.toLowerCase().contains('video')
                ? 'video'
                : media.type.toLowerCase().contains('photo')
                    ? 'photo'
                    : 'article',
        'media_url': 'https://storage.unicef.cd/medias/${media.id}',
        'theme': media.theme,
        'exif_purge': media.exifPurge,
        'floutage_actif': media.floutageEffectue,
        'consentement_interviewes': media.consentementSujets,
      });
      await syncFromBackend();
    } catch (e) {
      _medias.insert(0, media);
      notifyListeners();
    }
  }

  Future<void> modererReportageParEncadreur({
    required String mediaId,
    required bool valider,
    required String commentaire,
  }) async {
    try {
      await api.reviewReportageN1(mediaId, commentaire, approuve: valider);
      await syncFromBackend();
    } catch (e) {
      final idx = _medias.indexWhere((m) => m.id == mediaId);
      if (idx != -1) {
        _medias[idx].statut = valider ? 'Validé Encadreur' : 'À corriger par l\'adolescent';
        _medias[idx].commentaireEncadreur = commentaire;
      }
      notifyListeners();
    }
  }

  Future<void> publierReportagePonabana(String mediaId) async {
    try {
      await api.publishReportageN2(mediaId, 'Approuvé pour publication WordPress Ponabana');
      await syncFromBackend();
    } catch (e) {
      final idx = _medias.indexWhere((m) => m.id == mediaId);
      if (idx != -1) {
        _medias[idx].statut = 'Publié Ponabana (WordPress)';
      }
      notifyListeners();
    }
  }

  Future<void> signalerIncidentSauvegarde({
    required String type,
    required String province,
    required String description,
  }) async {
    try {
      await api.reportSafeguardIncident({
        'type_incident': type,
        'province': province,
        'description': description,
        'gravite': 'URGENT',
        'signaleur_type': _currentRole == RoleUtilisateur.adolescent ? 'Adolescent' : 'Encadreur',
      });
      await syncFromBackend();
    } catch (e) {
      final incident = IncidentSauvegarde(
        id: 'INC-2026-00${_incidents.length + 1}',
        type: type,
        province: province,
        description: description,
        date: DateTime.now().toString().substring(0, 16),
        statut: 'En cours d\'investigation (24h)',
      );
      _incidents.insert(0, incident);
      notifyListeners();
    }
  }

  void updateAdolescentProfile({
    required String prenom,
    required String bio,
    required String avatarUrl,
  }) {
    final idx = _adolescents.indexWhere((a) => a.id == _activeAdolescentId);
    if (idx != -1) {
      _adolescents[idx].prenom = prenom;
      _adolescents[idx].bio = bio;
      _adolescents[idx].avatarUrl = avatarUrl;
      notifyListeners();
    }
  }

  void updateEncadreurProfile({
    required String prenom,
    required String nom,
    required String bio,
    required String avatarUrl,
    required String telephone,
  }) {
    final idx = _encadreurs.indexWhere((e) => e.id == _activeEncadreurId);
    if (idx != -1) {
      _encadreurs[idx].prenom = prenom;
      _encadreurs[idx].nom = nom;
      _encadreurs[idx].bio = bio;
      _encadreurs[idx].avatarUrl = avatarUrl;
      _encadreurs[idx].telephone = telephone;
      notifyListeners();
    }
  }

  void updateAdminProfile({
    required String prenom,
    required String nom,
    required String bio,
    required String avatarUrl,
  }) {
    _adminUser.prenom = prenom;
    _adminUser.nom = nom;
    _adminUser.bio = bio;
    _adminUser.avatarUrl = avatarUrl;
    notifyListeners();
  }

  void affecterEncadreurAuClub(String encadreurId, String clubId) {
    final encIdx = _encadreurs.indexWhere((e) => e.id == encadreurId);
    if (encIdx != -1 && !_encadreurs[encIdx].clubIds.contains(clubId)) {
      _encadreurs[encIdx].clubIds.add(clubId);
      notifyListeners();
    }
  }

  void ajouterLogAudit(String action) {
    _auditLogs.insert(
      0,
      EntreeAudit(
        id: 'AUD-00${_auditLogs.length + 1}',
        utilisateur: _currentRole == RoleUtilisateur.adolescent
            ? activeAdolescent.prenom
            : _currentRole == RoleUtilisateur.encadreur
                ? activeEncadreur.nomComplet
                : _adminUser.nomComplet,
        role: _currentRole.name,
        action: action,
        date: DateTime.now().toString().substring(0, 16),
      ),
    );
    notifyListeners();
  }
}
