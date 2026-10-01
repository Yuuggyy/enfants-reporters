import 'package:enfants_reporters/data/seed/seed_data.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cohérence du contenu pédagogique : 6 modules, 18 micro-capsules,
/// 63 questions de quiz, chaque leçon rattachée à un module existant,
/// chaque question rattachée à une leçon existante, chaque badge
/// rattaché à un module existant.
void main() {
  test('6 modules définis', () {
    expect(SeedData.modules.length, 6);
    expect(
      SeedData.modules.map((m) => m.id).toSet(),
      containsAll([
        'mod_cde',
        'mod_interview',
        'mod_radio',
        'mod_plaidoyer',
        'mod_factcheck',
        'mod_cyber',
      ]),
    );
  });

  test('18 micro-capsules, toutes rattachées à un module', () {
    expect(SeedData.lessons.length, 18);
    final ids = SeedData.modules.map((m) => m.id).toSet();
    for (final l in SeedData.lessons) {
      expect(ids, contains(l.moduleId), reason: l.id);
    }
  });

  test('63 questions, toutes rattachées à une leçon', () {
    expect(SeedData.questions.length, 63);
    final ids = SeedData.lessons.map((l) => l.id).toSet();
    for (final q in SeedData.questions) {
      expect(ids, contains(q.lessonId), reason: q.id);
      expect(q.bonneReponse, lessThan(q.options.length), reason: q.id);
    }
  });

  test('6 badges, tous rattachés à un module', () {
    expect(SeedData.badges.length, 6);
    final ids = SeedData.modules.map((m) => m.id).toSet();
    for (final b in SeedData.badges) {
      expect(ids, contains(b.moduleId), reason: b.id);
    }
  });

  test('3 micro-capsules par module', () {
    for (final m in SeedData.modules) {
      final nb = SeedData.lessons.where((l) => l.moduleId == m.id).length;
      expect(nb, 3, reason: m.id);
    }
  });
}
