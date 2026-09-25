import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Un module de formation de l'Académie (ex. Droits de l'enfant).
class ModuleFormation extends Equatable {
  final String id;
  final String titre;
  final String description;
  final String emoji;
  final int couleurValue;
  final String badgeTitre;

  const ModuleFormation({
    required this.id,
    required this.titre,
    required this.description,
    required this.emoji,
    required this.couleurValue,
    required this.badgeTitre,
  });

  Color get couleur => Color(couleurValue);

  @override
  List<Object?> get props => [id, titre];
}
