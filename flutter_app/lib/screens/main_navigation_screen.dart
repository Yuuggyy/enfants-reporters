import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../services/i18n_service.dart';
import '../models/models.dart';
import '../widgets/safeguard_dialog.dart';
import '../widgets/banapp_logo.dart';
import 'login_screen.dart';
import 'child_home_tab.dart';
import 'child_club_tab.dart';
import 'academy_tab.dart';
import 'reporters_tab.dart';
import 'encadreur_club_tab.dart';
import 'encadreur_assisted_reg_tab.dart';
import 'encadreur_moderation_tab.dart';
import 'encadreur_rapidpro_tab.dart';
import 'admin_encadreurs_tab.dart';
import 'dashboard_tab.dart';
import 'admin_rapidpro_hub_tab.dart';
import 'admin_ponabana_safeguard_tab.dart';
import 'profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openSafeguardDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SafeguardDialog(),
    );
  }

  void _showAccountSwitchDialog(MockDatabaseService db) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bascule Rapide de Profil & Session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Testez les 3 rôles de l\'écosystème BanApp RDC :',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF00ADEF),
                  child: Icon(Icons.face_rounded, color: Colors.white),
                ),
                title: const Text('Enfant (Esther - Nsele)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Club Plaidoyer Nsele • Formations & Reportages', style: TextStyle(fontSize: 11)),
                selected: db.currentRole == RoleUtilisateur.adolescent,
                onTap: () {
                  db.switchRoleDirect(RoleUtilisateur.adolescent);
                  setState(() => _currentIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF0072F5),
                  child: Icon(Icons.groups_rounded, color: Colors.white),
                ),
                title: const Text('Encadreur (Alain Mukendi)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Superviseur Club Nsele • Inscription & Modération', style: TextStyle(fontSize: 11)),
                selected: db.currentRole == RoleUtilisateur.encadreur,
                onTap: () {
                  db.switchRoleDirect(RoleUtilisateur.encadreur);
                  setState(() => _currentIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF0F172A),
                  child: Icon(Icons.security_rounded, color: Colors.white),
                ),
                title: const Text('Admin UNICEF (Superviseur Global)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Superviseur Encadreurs • Hub RapidPro & Dashboard', style: TextStyle(fontSize: 11)),
                selected: db.currentRole == RoleUtilisateur.admin,
                onTap: () {
                  db.switchRoleDirect(RoleUtilisateur.admin);
                  setState(() => _currentIndex = 0);
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  db.logout();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                label: const Text('Se Déconnecter', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final i18n = Provider.of<I18nService>(context);

    if (!db.isLoggedIn) {
      return const LoginScreen();
    }

    // Role-specific Tabs & BottomNav
    final List<Widget> tabs;
    final List<BottomNavigationBarItem> navItems;

    if (db.currentRole == RoleUtilisateur.adolescent) {
      tabs = [
        ChildHomeTab(onNavigateToTab: _onTabTapped),
        const AcademyTab(),
        const ReportersTab(),
        const ChildClubTab(),
        const ProfileTab(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Mon Espace'),
        BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Académie'),
        BottomNavigationBarItem(icon: Icon(Icons.videocam_rounded), label: 'Reportages'),
        BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Mon Club'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Mon Profil'),
      ];
    } else if (db.currentRole == RoleUtilisateur.encadreur) {
      tabs = [
        const EncadreurClubTab(),
        const EncadreurAssistedRegTab(),
        const EncadreurModerationTab(),
        const EncadreurRapidproTab(),
        const ProfileTab(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Mon Club'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add_rounded), label: 'Inscription'),
        BottomNavigationBarItem(icon: Icon(Icons.rate_review_rounded), label: 'Modération'),
        BottomNavigationBarItem(icon: Icon(Icons.campaign_rounded), label: 'RapidPro'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Mon Profil'),
      ];
    } else {
      // Admin
      tabs = [
        const AdminEncadreursTab(),
        const DashboardTab(),
        const AdminRapidproHubTab(),
        const AdminPonabanaSafeguardTab(),
        const ProfileTab(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_rounded), label: 'Encadreurs'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.sync_alt_rounded), label: 'RapidPro Hub'),
        BottomNavigationBarItem(icon: Icon(Icons.public_rounded), label: 'Ponabana & PSE'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Mon Profil'),
      ];
    }

    final safeIndex = _currentIndex < tabs.length ? _currentIndex : 0;

    final roleLabel = db.currentRole == RoleUtilisateur.adolescent
        ? 'Enfant (${db.activeAdolescent.prenom})'
        : db.currentRole == RoleUtilisateur.encadreur
            ? 'Encadreur (${db.activeEncadreur.prenom})'
            : 'Admin UNICEF';

    final roleColor = db.currentRole == RoleUtilisateur.adolescent
        ? const Color(0xFF00ADEF)
        : db.currentRole == RoleUtilisateur.encadreur
            ? const Color(0xFF0072F5)
            : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            const BanAppLogo(size: 34, borderRadius: 8, hasShadow: false),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i18n.t('app_title'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showAccountSwitchDialog(db),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          roleLabel,
                          style: TextStyle(
                            fontSize: 10,
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down_rounded, size: 16, color: roleColor),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Language selector dropdown
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: i18n.currentLanguage,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                icon: const Icon(Icons.language_rounded, size: 16, color: Color(0xFF00ADEF)),
                items: i18n.languageNames.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    i18n.setLanguage(val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Safeguard Emergency Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _openSafeguardDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.shield_rounded, size: 16),
              label: Text(
                i18n.t('safeguard_btn'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Bouton Déconnexion Direct & Clair
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text('Se déconnecter ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: const Text(
                    'Voulez-vous fermer votre session active et revenir à l\'écran de connexion ?',
                    style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Annuler', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        db.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF64748B), size: 20),
            tooltip: 'Se déconnecter / Changer de compte',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildBackendStatusBanner(db),
          Expanded(
            child: IndexedStack(
              index: safeIndex,
              children: tabs,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: roleColor,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 0,
          items: navItems,
        ),
      ),
    );
  }

  Widget _buildBackendStatusBanner(MockDatabaseService db) {
    if (db.isBackendOnline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: const Color(0xFFF0FDF4),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Backend Python En Ligne (127.0.0.1:8000 • FastAPI/SQLite)',
                style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: db.isCheckingHealth
                  ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF166534)),
              onPressed: () => db.syncFromBackend(),
              tooltip: 'Rafraîchir depuis le backend',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        color: const Color(0xFFFEF2F2),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Serveur Python Déconnecté • Lancez \'python backend/run.py\'',
                style: TextStyle(fontSize: 11, color: Color(0xFF991B1B), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () => db.checkBackendStatus(),
              icon: db.isCheckingHealth
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF4444)))
                  : const Icon(Icons.sync_rounded, size: 14, color: Color(0xFFEF4444)),
              label: const Text('Tester',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: Size.zero),
            ),
          ],
        ),
      );
    }
  }
}
