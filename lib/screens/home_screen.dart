import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/repositories/academy_repository.dart';
import '../data/seed/seed_data.dart';
import '../state/app_controller.dart';
import '../widgets/stat_chips.dart';
import '../widgets/yuustore_footer.dart';
import 'lesson_screen.dart';

/// Tableau de bord : salutation, XP, série, prochaine capsule et missions.
class HomeScreen extends StatelessWidget {
  final AppController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final academy = AcademyRepository();
    final user = controller.utilisateur!;
    final prochaine = academy.prochaineLecon(controller.scores);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bonjour ${user.nomPublic} !'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: StatChip(
                icone: Icons.local_fire_department,
                libelle: '${controller.serie} j',
                couleur: AppTheme.corail,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatChip(
                  icone: Icons.stars,
                  libelle: '${controller.xp} XP',
                  couleur: AppTheme.jaune,
                ),
                StatChip(
                  icone: Icons.military_tech,
                  libelle: '${controller.badgesGagnes.length} badges',
                  couleur: AppTheme.violet,
                ),
                StatChip(
                  icone: Icons.workspace_premium,
                  libelle: controller.rang,
                  couleur: AppTheme.corail,
                ),
                StatChip(
                  icone: Icons.emoji_events,
                  libelle: '${controller.scores.length} leçons',
                  couleur: AppTheme.vert,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (prochaine != null)
            Card(
              color: AppTheme.cyan,
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 40),
                title: const Text(
                  'Continuer ma formation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  prochaine.titre,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      controller: controller,
                      lessonId: prochaine.id,
                    ),
                  ),
                ),
              ),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '🎉 Bravo ! Tu as terminé toute l\'Académie de la Phase 1. '
                  'Reviens bientôt pour de nouveaux modules.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'Missions de terrain',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          for (final m in SeedData.missions)
            Card(
              child: ListTile(
                leading: const Icon(Icons.flag, color: AppTheme.corail),
                title: Text(m['titre'] as String),
                subtitle: Text(m['description'] as String),
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'Journées à retenir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.calendar_month, color: AppTheme.bleu),
                  title: Text('16 juin'),
                  subtitle: Text('Journée de l\'enfant africain'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month, color: AppTheme.bleu),
                  title: Text('20 novembre'),
                  subtitle: Text('Journée mondiale de l\'enfance'),
                ),
              ],
            ),
          ),
          const YuuStoreFooter(),
        ],
      ),
    );
  }
}

