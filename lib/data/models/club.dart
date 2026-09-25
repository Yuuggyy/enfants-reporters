import 'package:equatable/equatable.dart';

/// Club d'enfants reporters (école ou centre communautaire).
class Club extends Equatable {
  final String id;
  final String nom;
  final String province;
  final String ville;
  final String ecole;
  final int nbEnfants;
  final String mentorNom;

  const Club({
    required this.id,
    required this.nom,
    required this.province,
    required this.ville,
    required this.ecole,
    required this.nbEnfants,
    required this.mentorNom,
  });

  @override
  List<Object?> get props => [id];
}
