import 'package:flutter/material.dart';

import '../data/models/lesson.dart';
import '../data/repositories/academy_repository.dart';
import '../state/app_controller.dart';
import 'lesson_screen.dart';

/// Détail d'un module : liste des micro-capsules et leur statut.
class ModuleDetailScreen extends StatelessWidget {
  final AppController controller;
  final String moduleId;

  const ModuleDetailScreen({
    super.key,
    required this.controller,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    final academy = AcademyRepository();
    final m = academy.module(moduleId)!;
    final lecons = academy.leconsDe(moduleId);
    return Scaffold(
      appBar: AppBar(title: Text(m.titre)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              m.description,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          for (final Lesson l in lecons)
            Builder(
              builder: (context) {
                final t = academy.questionsDe(l.id).length;
                final score = controller.scores[l.id] ?? 0;
                final valid = score >= (t * 0.75).ceil();
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          valid ? m.couleur : const Color(0xFFE2EDF4),
                      child: valid
                          ? const Icon(Icons.check, color: Colors.white)
                          : Text('${l.ordre}'),
                    ),
                    title: Text(l.titre),
                    subtitle: Text(
                      valid
                          ? 'Validée  •  score $score/$t'
                          : 'Capsule de ${l.dureeMinutes} minutes + quiz',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(
                          controller: controller,
                          lessonId: l.id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
