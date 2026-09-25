import 'package:flutter/material.dart';

import '../state/app_controller.dart';

/// Consentement parental numérique, exigé par le Code de l'enfant
/// (loi 09/011) et le Code du numérique RDC avant l'accès au contenu.
class ConsentScreen extends StatefulWidget {
  final AppController controller;

  const ConsentScreen({super.key, required this.controller});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _tuteurCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  bool _caseCochee = false;

  @override
  void dispose() {
    _tuteurCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (_tuteurCtrl.text.trim().isEmpty ||
        _telCtrl.text.trim().isEmpty ||
        !_caseCochee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Remplis les informations du tuteur et coche l\'autorisation.',
          ),
        ),
      );
      return;
    }
    final u = widget.controller.utilisateur!.copyWith(
      tuteurNom: _tuteurCtrl.text.trim(),
      tuteurTelephone: _telCtrl.text.trim(),
      consentementParental: true,
    );
    await widget.controller.mettreAJourProfil(u);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autorisation parentale'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gpp_good, color: Color(0xFF1CABE2)),
                    SizedBox(width: 8),
                    Text(
                      'Ton compte est créé !',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Avant de commencer, la loi congolaise (Code de l\'enfant, '
                  'loi 09/011) exige l\'accord de ton parent ou tuteur. '
                  'Demande-lui de compléter cette étape avec toi.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _tuteurCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nom du parent ou tuteur',
              prefixIcon: Icon(Icons.family_restroom),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _telCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Téléphone du tuteur',
              prefixIcon: Icon(Icons.phone_android),
            ),
          ),
          CheckboxListTile(
            value: _caseCochee,
            onChanged: (v) => setState(() => _caseCochee = v ?? false),
            title: const Text(
              'J\'autorise mon enfant à utiliser cette application et '
              'j\'accepte que ses productions soient publiées après '
              'validation par les modérateurs.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Activer mon compte'),
            onPressed: _valider,
          ),
        ],
      ),
    );
  }
}
