import 'package:equatable/equatable.dart';

/// Une question de quiz à choix multiples avec explication pédagogique.
class QuizQuestion extends Equatable {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int bonneReponse;
  final String explication;

  const QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.bonneReponse,
    required this.explication,
  });

  @override
  List<Object?> get props => [id];
}
