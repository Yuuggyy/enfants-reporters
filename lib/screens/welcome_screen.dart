import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../state/app_controller.dart';
import '../widgets/yuustore_footer.dart';
import 'role_selection_screen.dart';

/// Écran d'accueil : logo, nom de l'app et bouton Commencer.
class WelcomeScreen extends StatelessWidget {
  final AppController controller;

  const WelcomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppTheme.cyan,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.record_voice_over,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Commencer'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RoleSelectionScreen(controller: controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Un projet de formation des enfants reporters\nen République Démocratique du Congo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
              const YuuStoreFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
