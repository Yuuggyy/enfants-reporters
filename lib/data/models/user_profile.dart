import 'package:equatable/equatable.dart';

/// Rôles disponibles dans la plateforme.
enum UserRole { enfant, mentor, moderateur, parent }

/// Profil utilisateur (enfant reporter ou encadrant).
class UserProfile extends Equatable {
  final String id;
  final String nom;
  final String pseudo;
  final UserRole role;
  final String? province;
  final String? clubId;
  final String? tuteurNom;
  final String? tuteurTelephone;
  final String? tuteurPin;
  final bool consentementParental;

  const UserProfile({
    required this.id,
    required this.nom,
    this.pseudo = '',
    required this.role,
    this.province,
    this.clubId,
    this.tuteurNom,
    this.tuteurTelephone,
    this.tuteurPin,
    this.consentementParental = false,
  });

  bool get estEnfant => role == UserRole.enfant;

  /// Nom affiché publiquement : pseudo si défini, sinon prénom.
  String get nomPublic =>
      pseudo.isNotEmpty ? pseudo : nom.split(' ').first;

  UserProfile copyWith({
    String? tuteurNom,
    String? tuteurTelephone,
    String? tuteurPin,
    bool? consentementParental,
  }) =>
      UserProfile(
        id: id,
        nom: nom,
        pseudo: pseudo,
        role: role,
        province: province,
        clubId: clubId,
        tuteurNom: tuteurNom ?? this.tuteurNom,
        tuteurTelephone: tuteurTelephone ?? this.tuteurTelephone,
        tuteurPin: tuteurPin ?? this.tuteurPin,
        consentementParental:
            consentementParental ?? this.consentementParental,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'pseudo': pseudo,
        'role': role.name,
        'province': province,
        'clubId': clubId,
        'tuteurNom': tuteurNom,
        'tuteurTelephone': tuteurTelephone,
        'tuteurPin': tuteurPin,
        'consentementParental': consentementParental,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        nom: json['nom'] as String,
        pseudo: (json['pseudo'] ?? '') as String,
        role: UserRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => UserRole.enfant,
        ),
        province: json['province'] as String?,
        clubId: json['clubId'] as String?,
        tuteurNom: json['tuteurNom'] as String?,
        tuteurTelephone: json['tuteurTelephone'] as String?,
        tuteurPin: json['tuteurPin'] as String?,
        consentementParental: (json['consentementParental'] ?? false) as bool,
      );

  @override
  List<Object?> get props => [id, nom, pseudo, role, consentementParental];
}
