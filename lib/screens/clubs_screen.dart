import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/repositories/club_repository.dart';
import '../widgets/yuustore_footer.dart';

/// Annuaire des clubs d'enfants reporters, groupés par province.
class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ClubRepository();
    final provinces = repo.provinces.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Clubs Enfants Reporters')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final province in provinces) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                province,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.bleu,
                ),
              ),
            ),
            for (final club in repo.parProvince(province))
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.cyan,
                    child: Icon(Icons.groups, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    club.nom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${club.ville}  •  ${club.ecole}\n'
                    '${club.nbEnfants} enfants  •  Mentor : ${club.mentorNom}',
                  ),
                  isThreeLine: true,
                ),
              ),
          ],
          const YuuStoreFooter(),
        ],
      ),
    );
  }
}
