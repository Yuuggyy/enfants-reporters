import 'package:flutter/material.dart';

import '../data/models/user_profile.dart';
import '../state/app_controller.dart';

/// Choix du rôle puis saisie du nom (authentification simulée
/// en Phase 1, prête pour l'API Laravel en Phase 2).
class RoleSelectionScreen extends StatefulWidget {
  final AppController controller;

  const RoleSelectionScreen({super.key, required this.controller});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _role;
  final _nomCtrl = TextEditingController();
  final _pseudoCtrl = TextEditingController();

  static const _roles = {
    UserRole.enfant: ('Enfant Reporter', 'Je me forme et je crée', Icons.record_voice_over),
    UserRole.mentor: ('Mentor de club', 'J\'encadre un club', Icons.supervisor_account),
    UserRole.moderateur: ('Modérateur', 'Je valide les contenus', Icons.verified_user),
    UserRole.parent: ('Parent / Tuteur', 'Je suis la formation', Icons.family_restroom),
  };

  @override
  void dispose() {
    _nomCtrl.dispose();
    _pseudoCtrl.dispose();
    super.dispose();
  }

  void _seConnecter() {
    if (_role == null || _nomCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisis un rôle et entre ton nom.')),
      );
      return;
    }
    final u = UserProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nom: _nomCtrl.text.trim(),
      pseudo: _pseudoCtrl.text.trim(),
      role: _role!,
    );
    widget.controller.connecter(u);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Qui es-tu ?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          for (final e in _roles.entries)
            Card(
              color: _role == e.key
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              child: ListTile(
                leading: Icon(
                  e.value.$3,
                  color: _role == e.key ? Colors.white : Colors.black54,
                ),
                title: Text(
                  e.value.$1,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _role == e.key ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  e.value.$2,
                  style: TextStyle(
                    color: _role == e.key ? Colors.white70 : Colors.black45,
                  ),
                ),
                onTap: () => setState(() => _role = e.key),
              ),
            ),
          const SizedBox(height: 24),
          TextField(
            controller: _nomCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pseudoCtrl,
            decoration: const InputDecoration(
              labelText: 'Pseudo (facultatif, protège ta vie privée)',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Entrer dans l\'application'),
            onPressed: _seConnecter,
          ),
        ],
      ),
    );
  }
}
