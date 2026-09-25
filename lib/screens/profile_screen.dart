import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/academy_repository.dart';
import '../data/seed/seed_data.dart';
import '../state/app_controller.dart';
import '../widgets/stat_chips.dart';
import '../widgets/yuustore_footer.dart';

/// Profil : CV de reporter, badges, signalement SOS et déconnexion.
class ProfileScreen extends StatelessWidget {
  final AppController controller;

  const ProfileScreen({super.key, required this.controller});

  void _sos(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('SOS - Signalement'),
        content: const Text(
          'Si tu vois quelque chose qui te met mal à l\'aise '
          '(harcèlement, message suspect, danger), préviens tout de suite '
          'un adulte de confiance : ton mentor de club, tes parents ou ton '
          'point focal protection de l\'enfance. '
          'Tu peux aussi quitter la conversation et en parler à ton '
          'encadreur UNICEF. Tu ne dois jamais gérer ça seul.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('J\'ai compris'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final academy = AcademyRepository();
    final user = controller.utilisateur!;
    final nbLecons = controller.scores.length;
    final nbBadges = controller.badgesGagnes.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Signaler un problème',
            onPressed: () => _sos(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 12),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppTheme.cyan,
              child: Text(
                user.nom.isNotEmpty ? user.nom[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              user.nom,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Center(
            child: Text(
              switch (user.role) {
                UserRole.enfant => 'Enfant Reporter',
                UserRole.mentor => 'Mentor de club',
                UserRole.moderateur => 'Modérateur',
                UserRole.parent => 'Parent / Tuteur',
              },
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatChip(icone: Icons.stars, libelle: '${controller.xp} XP', couleur: AppTheme.jaune),
                StatChip(icone: Icons.local_fire_department, libelle: '${controller.serie} jours de série', couleur: AppTheme.corail),
                StatChip(icone: Icons.military_tech, libelle: '$nbBadges badges', couleur: AppTheme.violet),
                StatChip(icone: Icons.workspace_premium, libelle: controller.rang, couleur: AppTheme.bleu),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mon CV de Reporter',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text('• Capsules validées : $nbLecons'),
                  Text('• Badges de compétence : $nbBadges/${academy.badges.length}'),
                  Text('• Consentement parental : ${user.consentementParental ? 'enregistré ✓' : 'à compléter'}'),
                  Text('• Rang actuel : ${controller.rang}'),
                  if (user.tuteurNom != null)
                    Text('• Tuteur : ${user.tuteurNom}'),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'Mes badges',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final b in SeedData.badges)
                  Chip(
                    avatar: Text(b.emoji),
                    label: Text(b.titre),
                    backgroundColor: controller.badgesGagnes.contains(b.id)
                        ? const Color(0xFFE4F7EC)
                        : const Color(0xFFF0F0F0),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              onPressed: () async {
                await controller.deconnecter();
              },
            ),
          ),
          const YuuStoreFooter(),
        ],
      ),
    );
  }
}
