import 'package:equatable/equatable.dart';

/// Une micro-capsule de formation (3 à 5 minutes).
class Lesson extends Equatable {
  final String id;
  final String moduleId;
  final String titre;
  final int dureeMinutes;
  final int ordre;
  final List<String> paragraphes;

  const Lesson({
    required this.id,
    required this.moduleId,
    required this.titre,
    required this.dureeMinutes,
    required this.ordre,
    required this.paragraphes,
  });

  @override
  List<Object?> get props => [id, moduleId, ordre];
}
