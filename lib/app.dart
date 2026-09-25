import 'package:flutter/material.dart';

import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'screens/consent_screen.dart';
import 'screens/home_shell.dart';
import 'screens/welcome_screen.dart';
import 'state/app_controller.dart';

/// Point d'entrée visuel de l'application Enfants Reporters RDC.
class EnfantsReportersApp extends StatelessWidget {
  final AppController controller;

  const EnfantsReportersApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _Portail(controller: controller),
    );
  }
}

/// Route racine : accueil, connexion (mock) puis coquille principale.
class _Portail extends StatefulWidget {
  final AppController controller;

  const _Portail({required this.controller});

  @override
  State<_Portail> createState() => _PortailState();
}

class _PortailState extends State<_Portail> {
  bool _charge = true;

  @override
  void initState() {
    super.initState();
    widget.controller.charger().then((_) {
      if (mounted) setState(() => _charge = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_charge) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final c = widget.controller;
        Widget dest;
        if (!c.estConnecte) {
          dest = WelcomeScreen(controller: c);
        } else if (c.utilisateur!.estEnfant &&
            !c.utilisateur!.consentementParental) {
          dest = ConsentScreen(controller: c);
        } else {
          dest = HomeShell(controller: c);
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(dest.runtimeType),
            child: dest,
          ),
        );
      },
    );
  }
}
