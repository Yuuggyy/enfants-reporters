import 'package:flutter/material.dart';

import '../data/repositories/academy_repository.dart';
import '../state/app_controller.dart';
import '../widgets/yuustore_footer.dart';
import 'module_detail_screen.dart';

/// Liste des modules de formation de l'Académie avec progression.
class AcademyScreen extends StatelessWidget {
  final AppController controller;

  const AcademyScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final academy = AcademyRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Académie')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: academy.modules.length + 1,
        itemBuilder: (context, i) {
          if (i == academy.modules.length) return const YuuStoreFooter();
          final m = academy.modules[i];
          final lecons = academy.leconsDe(m.id);
          final faites = lecons.where((l) {
            final t = academy.questionsDe(l.id).length;
            return (controller.scores[l.id] ?? 0) >= (t * 0.75).ceil();
          }).length;
          final progression = lecons.isEmpty
              ? 0.0
              : faites / lecons.length;
          final badge = academy.badgeDuModule(m.id);
          final obtenu =
              badge != null && controller.badgesGagnes.contains(badge.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: m.couleur,
                child: Text(
                  m.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                m.titre,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progression,
                    backgroundColor: const Color(0xFFE2EDF4),
                    color: m.couleur,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${faites}/${lecons.length} capsules'
                    '${obtenu ? '  •  Badge obtenu 🏅' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ModuleDetailScreen(
                    controller: controller,
                    moduleId: m.id,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
