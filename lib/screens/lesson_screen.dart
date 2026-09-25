import 'package:flutter/material.dart';

import '../data/repositories/academy_repository.dart';
import '../state/app_controller.dart';
import 'quiz_screen.dart';

/// Lecture d'une micro-capsule (texte structuré, 3 à 5 minutes).
class LessonScreen extends StatelessWidget {
  final AppController controller;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.controller,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    final academy = AcademyRepository();
    final lesson = academy.lecon(lessonId)!;
    final nbQuestions = academy.questionsDe(lessonId).length;
    return Scaffold(
      appBar: AppBar(title: Text(lesson.titre)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Chip(
                  avatar: const Icon(Icons.schedule, size: 18),
                  label: Text('${lesson.dureeMinutes} minutes de lecture'),
                ),
                const SizedBox(height: 16),
                for (final p in lesson.paragraphes) ...[
                  Text(
                    p,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.quiz),
                  label: Text('Passer le quiz ($nbQuestions questions)'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        controller: controller,
                        lessonId: lessonId,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
