import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'state/app_controller.dart';

void main() {
  // Filet de sécurité : une erreur imprévue s'affiche à l'écran au lieu
  // de fermer brutalement l'application (utile pour diagnostiquer un bug
  // en conditions réelles, sur un vrai téléphone).
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    final controller = AppController();
    runApp(EnfantsReportersApp(controller: controller));
  }, (error, stack) {
    debugPrint('Erreur non interceptée : $error\n$stack');
  });
}
