import '../models/badge.dart';
import '../models/lesson.dart';
import '../models/module.dart';
import '../models/quiz_question.dart';
import '../seed/seed_data.dart';

/// Accès aux données de l'Académie (Phase 1 : contenu local seedé ;
/// Phase 2 : branchement sur l'API Laravel auto-hébergé).
class AcademyRepository {
  List<ModuleFormation> get modules => SeedData.modules;

  List<Lesson> leconsDe(String moduleId) =>
      SeedData.lessons.where((l) => l.moduleId == moduleId).toList()..sort((a, b) => a.ordre.compareTo(b.ordre));

  List<QuizQuestion> questionsDe(String lessonId) =>
      SeedData.questions.where((q) => q.lessonId == lessonId).toList();

  Lesson? lecon(String lessonId) {
    for (final l in SeedData.lessons) {
      if (l.id == lessonId) return l;
    }
    return null;
  }

  ModuleFormation? module(String moduleId) {
    for (final m in SeedData.modules) {
      if (m.id == moduleId) return m;
    }
    return null;
  }

  List<BadgeCompetence> get badges => SeedData.badges;

  BadgeCompetence? badgeDuModule(String moduleId) {
    for (final b in SeedData.badges) {
      if (b.moduleId == moduleId) return b;
    }
    return null;
  }

  /// Prochaine capsule non encore validée par l'enfant.
  Lesson? prochaineLecon(Map<String, int> scores) {
    for (final m in SeedData.modules) {
      for (final l in leconsDe(m.id)) {
        final total = questionsDe(l.id).length;
        final score = scores[l.id] ?? 0;
        if (score < (total * 0.75).ceil()) return l;
      }
    }
    return null;
  }
}
