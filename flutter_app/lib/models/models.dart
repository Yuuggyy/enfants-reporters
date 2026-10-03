// Modèles de données pour l'écosystème digital UNICEF RDC (CPD 2025-2029)

enum StatutConsentement {
  enAttente,
  valide,
  refuse,
  revoque,
}

enum CanalInscription {
  web,
  whatsapp,
  sms,
  ussd,
  assiste,
}

enum RoleUtilisateur {
  adolescent,
  encadreur,
  admin,
}

class ClubEngagement {
  final String id;
  final String nom;
  final String province;
  final String ville;
  final String theme;
  final String encadreurId;
  final String encadreurNom;
  final String encadreurTelephone;
  final String groupeWhatsappRapidPro;
  final String prochaineActivite;
  int nombreMembres;

  ClubEngagement({
    required this.id,
    required this.nom,
    required this.province,
    required this.ville,
    required this.theme,
    required this.encadreurId,
    required this.encadreurNom,
    required this.encadreurTelephone,
    required this.groupeWhatsappRapidPro,
    required this.prochaineActivite,
    required this.nombreMembres,
  });
}

class Encadreur {
  final String id;
  String nom;
  String prenom;
  String email;
  String telephone;
  String organisation; // ex: 'REIPE', 'Ministère Genre & Enfant'
  final String province;
  final String ville;
  String bio;
  String avatarUrl;
  final List<String> clubIds;
  final String datePriseFonction;
  bool actif;

  Encadreur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.organisation,
    required this.province,
    required this.ville,
    this.bio = 'Encadreur passionné par l\'accompagnement et la protection des jeunes reporters.',
    this.avatarUrl = 'avatar_encadreur_1',
    required this.clubIds,
    required this.datePriseFonction,
    this.actif = true,
  });

  String get nomComplet => '$prenom $nom';
  String get pseudo => '@${prenom.toLowerCase()}_${nom.toLowerCase()}';
}

class AdminUser {
  final String id;
  String nom;
  String prenom;
  String email;
  String section; // ex: 'UNICEF C&A (Communication & Plaidoyer)', 'UNICEF T4D', 'UNICEF PSE'
  String roleTitre;
  String bio;
  String avatarUrl;
  final bool doubleFacteurActif;

  AdminUser({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.section,
    required this.roleTitre,
    this.bio = 'Superviseur National & Administrateur Global de l\'écosystème BanApp RDC.',
    this.avatarUrl = 'avatar_admin_1',
    this.doubleFacteurActif = true,
  });

  String get nomComplet => '$prenom $nom';
  String get pseudo => '@unicef_${prenom.toLowerCase()}';
}

class Adolescent {
  final String id;
  String prenom;
  final int age;
  final String sexe;
  final String province;
  final String ville;
  final String milieu;
  final String statutScolaire;
  final bool situationHandicap;
  final String languePreferee;
  final String telephone;
  final String telephoneParent;
  final String clubId;
  String bio;
  String avatarUrl;
  int pointsXp;
  final CanalInscription canal;
  StatutConsentement statutConsentement;
  final String modeConsentement;
  final int progressionFormation; // 0 à 100 %
  final bool certifie;
  final String codeCertificat;
  final String dateInscription;
  final List<String> badges;
  final bool anonymise;

  Adolescent({
    required this.id,
    required this.prenom,
    required this.age,
    required this.sexe,
    required this.province,
    required this.ville,
    required this.milieu,
    required this.statutScolaire,
    required this.situationHandicap,
    required this.languePreferee,
    required this.telephone,
    required this.telephoneParent,
    required this.clubId,
    this.bio = 'Adolescent engagé pour les droits de l\'enfant et le plaidoyer en RDC 🇨🇩✨',
    this.avatarUrl = 'avatar_ado_1',
    this.pointsXp = 380,
    required this.canal,
    required this.statutConsentement,
    required this.modeConsentement,
    required this.progressionFormation,
    required this.certifie,
    required this.codeCertificat,
    required this.dateInscription,
    required this.badges,
    this.anonymise = false,
  });

  String get pseudo => '@${prenom.toLowerCase()}_${ville.toLowerCase()}';
}

class QuestionQuiz {
  final String question;
  final List<String> options;
  final int indexCorrect;
  final String feedback;

  QuestionQuiz({
    required this.question,
    required this.options,
    required this.indexCorrect,
    required this.feedback,
  });
}

class ModuleFormation {
  final int numero;
  final String titre;
  final String duree;
  final String description;
  final String categorie;
  final String audioSummary;
  final List<String> pointsCles;
  final List<QuestionQuiz> quiz;
  bool complete;
  int? scoreQuiz;

  ModuleFormation({
    required this.numero,
    required this.titre,
    required this.duree,
    required this.description,
    required this.categorie,
    required this.audioSummary,
    required this.pointsCles,
    required this.quiz,
    this.complete = false,
    this.scoreQuiz,
  });
}

class ContenuMedia {
  final String id;
  final String auteurId;
  final String auteurPrenom;
  final String clubId;
  final String titre;
  final String type; // 'Texte / Article', 'Photo / Reportage', 'Audio', 'Vidéo'
  final String province;
  final String theme;
  final String resume;
  final bool consentementSujets;
  final bool floutageEffectue;
  final bool exifPurge;
  String statut; // 'En attente modération (Encadreur)', 'Validé Encadreur', 'Publié Ponabana (WordPress)'
  String? commentaireEncadreur;
  final String dateSoumission;

  ContenuMedia({
    required this.id,
    required this.auteurId,
    required this.auteurPrenom,
    required this.clubId,
    required this.titre,
    required this.type,
    required this.province,
    required this.theme,
    required this.resume,
    required this.consentementSujets,
    required this.floutageEffectue,
    required this.exifPurge,
    required this.statut,
    this.commentaireEncadreur,
    required this.dateSoumission,
  });
}

class IncidentSauvegarde {
  final String id;
  final String type;
  final String province;
  final String description;
  final String date;
  String statut; // 'En cours d\'investigation (24h)', 'Traité', 'Clôturé'

  IncidentSauvegarde({
    required this.id,
    required this.type,
    required this.province,
    required this.description,
    required this.date,
    required this.statut,
  });
}

class EntreeAudit {
  final String id;
  final String utilisateur;
  final String role;
  final String action;
  final String date;

  EntreeAudit({
    required this.id,
    required this.utilisateur,
    required this.role,
    required this.action,
    required this.date,
  });
}

class NotificationEncadreur {
  final String id;
  final String encadreurId;
  final String? adolescentId;
  final String? adolescentNom;
  final String? clubNom;
  final String date;
  final String message;
  bool traitee;

  NotificationEncadreur({
    required this.id,
    required this.encadreurId,
    this.adolescentId,
    this.adolescentNom,
    this.clubNom,
    required this.date,
    required this.message,
    this.traitee = false,
  });
}

class MessageRapidPro {
  final String id;
  final String emetteur;
  final String destinataire; // Nom du club, groupe ou national
  final String canal; // 'WhatsApp', 'SMS', 'USSD'
  final String texte;
  final String dateEnvoi;
  final String statut; // 'Délivré', 'En cours', 'Reçu'

  MessageRapidPro({
    required this.id,
    required this.emetteur,
    required this.destinataire,
    required this.canal,
    required this.texte,
    required this.dateEnvoi,
    required this.statut,
  });
}

class SocialComment {
  final String id;
  final String auteurNom;
  final String auteurAvatar;
  final String texte;
  final String date;

  SocialComment({
    required this.id,
    required this.auteurNom,
    required this.auteurAvatar,
    required this.texte,
    required this.date,
  });
}

class SocialPost {
  final String id;
  final String auteurId;
  final String auteurNom;
  final String auteurRole; // 'Adolescent Reporter', 'Encadreur REIPE', 'UNICEF Officiel'
  final String auteurAvatar;
  final String auteurVille;
  final String clubNom;
  final String texte;
  final String? imageType; // 'plaidoyer', 'atelier', 'ceremonie', null
  final String date;
  int likesCount;
  bool isLiked;
  final List<String> tags;
  final List<SocialComment> commentaires;

  SocialPost({
    required this.id,
    required this.auteurId,
    required this.auteurNom,
    required this.auteurRole,
    required this.auteurAvatar,
    required this.auteurVille,
    required this.clubNom,
    required this.texte,
    this.imageType,
    required this.date,
    this.likesCount = 0,
    this.isLiked = false,
    this.tags = const [],
    this.commentaires = const [],
  });
}
