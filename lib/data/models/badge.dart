import 'package:equatable/equatable.dart';

/// Badge de compétence débloqué à la fin d'un module.
class BadgeCompetence extends Equatable {
  final String id;
  final String titre;
  final String description;
  final String emoji;
  final String moduleId;

  const BadgeCompetence({
    required this.id,
    required this.titre,
    required this.description,
    required this.emoji,
    required this.moduleId,
  });

  @override
  List<Object?> get props => [id];
}
