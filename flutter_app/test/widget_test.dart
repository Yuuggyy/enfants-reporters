import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/services/mock_database.dart';
import 'package:flutter_app/models/models.dart';

void main() {
  testWidgets('Test de chargement de l\'écran de connexion propre et navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const BanApp());
    expect(find.text('BanApp'), findsWidgets);
    expect(find.text('Engagement & Rôles RDC'), findsOneWidget);

    // Vérification de la présence des 3 portails d'accès
    expect(find.text('Enfant (12-17)'), findsOneWidget);
    expect(find.text('Encadreur Club'), findsOneWidget);
    expect(find.text('Admin UNICEF'), findsOneWidget);
  });

  test('Test unitaire : Base 100% propre, inscription dynamique, soumission reportage et fil social', () async {
    final db = MockDatabaseService();

    // 1. État initial : base totalement vide de données mockées
    expect(db.adolescents.isEmpty, true);
    expect(db.medias.isEmpty, true);
    expect(db.socialPosts.isEmpty, true);
    expect(db.incidents.isEmpty, true);
    expect(db.modules.every((m) => !m.complete), true);

    // 2. Inscription d'un nouvel adolescent
    final nouvelAdo = Adolescent(
      id: 'ADO-TEST-001',
      prenom: 'Ketsia',
      age: 15,
      sexe: 'F',
      province: 'Kinshasa',
      ville: 'Nsele',
      milieu: 'Urbain',
      statutScolaire: 'Scolarisé(e)',
      situationHandicap: false,
      languePreferee: 'Lingála',
      telephone: '+243819998877',
      telephoneParent: '+243819998800',
      clubId: 'CLUB-KIN-01',
      canal: CanalInscription.web,
      statutConsentement: StatutConsentement.enAttente,
      modeConsentement: 'Web',
      progressionFormation: 0,
      certifie: false,
      codeCertificat: '',
      dateInscription: '2026-10-02',
      badges: [],
    );
    await db.ajouterAdolescent(nouvelAdo);
    expect(db.adolescents.length, 1);
    expect(db.adolescents.first.prenom, 'Ketsia');

    // 3. Connexion de l'adolescent
    final loginOk = await db.loginAsChild('ADO-TEST-001');
    expect(loginOk, true);
    expect(db.isLoggedIn, true);
    expect(db.currentRole, RoleUtilisateur.adolescent);
    expect(db.activeAdolescent.id, 'ADO-TEST-001');

    // 4. Soumission d'un reportage par l'enfant (sans droit de publication directe)
    final media = ContenuMedia(
      id: 'TEST-MED-01',
      auteurId: db.activeAdolescent.id,
      auteurPrenom: db.activeAdolescent.prenom,
      clubId: db.activeAdolescent.clubId,
      titre: 'Reportage Test Plaidoyer',
      type: 'Photo / Reportage',
      province: 'Kinshasa',
      theme: 'Éducation',
      resume: 'Test de conformité des droits',
      consentementSujets: true,
      floutageEffectue: true,
      exifPurge: true,
      statut: 'En attente modération (Encadreur)',
      dateSoumission: '2026-10-02',
    );
    await db.soumettreReportage(media);
    expect(db.medias.length, 1);
    expect(db.medias.first.statut, 'En attente modération (Encadreur)');

    // 5. Modération par l'encadreur
    db.switchRoleDirect(RoleUtilisateur.encadreur);
    await db.modererReportageParEncadreur(
      mediaId: 'TEST-MED-01',
      valider: true,
      commentaire: 'Vérifié et conforme',
    );
    expect(db.medias.first.statut, 'Validé Encadreur');

    // 6. Publication par l'Admin
    db.switchRoleDirect(RoleUtilisateur.admin);
    await db.publierReportagePonabana('TEST-MED-01');
    expect(db.medias.first.statut, 'Publié Ponabana (WordPress)');

    // 7. Déconnexion
    db.logout();
    expect(db.isLoggedIn, false);
  });
}
