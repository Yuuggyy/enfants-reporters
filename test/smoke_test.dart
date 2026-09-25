import 'package:enfants_reporters/app.dart';
import 'package:enfants_reporters/data/models/user_profile.dart';
import 'package:enfants_reporters/state/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('demarrage jusqu a l accueil', (tester) async {
    final c = AppController();
    await tester.pumpWidget(EnfantsReportersApp(controller: c));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Commencer'), findsOneWidget);
  });

  testWidgets('parcours complet enfant avec PIN', (tester) async {
    final c = AppController();
    await c.connecter(const UserProfile(
      id: '1',
      nom: 'Test Enfant',
      role: UserRole.enfant,
    ));
    await tester.pumpWidget(EnfantsReportersApp(controller: c));
    await tester.pumpAndSettle();
    expect(find.text('Autorisation parentale'), findsOneWidget);
    final champs = find.byType(TextField);
    await tester.enterText(champs.at(0), 'Tuteur Test');
    await tester.enterText(champs.at(1), '+243900000000');
    await tester.enterText(champs.at(2), '1234');
    await tester.enterText(champs.at(3), '1234');
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Activer mon compte'));
    await tester.tap(find.text('Activer mon compte'));
    await tester.pumpAndSettle();
    expect(find.text('Bonjour Test !'), findsOneWidget);
    expect(find.text('Débutant'), findsWidgets);
    await tester.tap(find.text('Académie'));
    await tester.pumpAndSettle();
    expect(find.text('Droits de l\'enfant'), findsOneWidget);
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Studio Reporter'), findsOneWidget);
    await tester.tap(find.text('Clubs'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Club Amani'), 200);
    expect(find.text('Club Amani'), findsOneWidget);
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Mon profil'), findsOneWidget);
  });
}
