import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import 'academy_screen.dart';
import 'clubs_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'studio_screen.dart';

/// Coquille principale avec la barre de navigation à 5 onglets.
class HomeShell extends StatefulWidget {
  final AppController controller;

  const HomeShell({super.key, required this.controller});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _onglet = 0;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final ecrans = [
      HomeScreen(controller: c),
      AcademyScreen(controller: c),
      const StudioScreen(),
      const ClubsScreen(),
      ProfileScreen(controller: c),
    ];
    return Scaffold(
      body: IndexedStack(index: _onglet, children: ecrans),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (i) => setState(() => _onglet = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Académie'),
          NavigationDestination(icon: Icon(Icons.edit_note_outlined), selectedIcon: Icon(Icons.edit_note), label: 'Studio'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
