import 'package:flutter/material.dart';

/// Thème Material 3 de l'application, inspiré du design « PulseJeune Hub »
/// (https://pulse-jeune-hub.base44.app) : thème sombre bleu nuit, accent
/// principal BLEU électrique (au lieu du vert lime de la référence, sur
/// demande du client), rose-rouge pour les actions destructives, coins très
/// arrondis (20 px) et typos Plus Jakarta Sans (titres) + Inter (corps).
class AppTheme {
  // --- Palette PulseJeune adaptée (accent bleu) ---
  /// Accent principal : bleu électrique.
  static const Color cyan = Color(0xFF3B82F6);

  /// Bleu clair pour icônes et éléments secondaires sur fond sombre.
  static const Color bleu = Color(0xFF6FA8FF);

  /// Jaune chaud conservé comme accent d'engagement (XP, succès).
  static const Color jaune = Color(0xFFFECB00);

  /// Rose-rouge (destructive PulseJeune) pour alertes et erreurs.
  static const Color corail = Color(0xFFFF5B68);

  /// Violet adouci pour la gamification, lisible sur fond sombre.
  static const Color violet = Color(0xFF9F7BF0);

  /// Vert validé pour les réussites de quiz.
  static const Color vert = Color(0xFF2FBF71);

  // --- Surfaces du thème sombre ---
  /// Fond bleu nuit (hsl 228 28% 7%).
  static const Color fond = Color(0xFF0D0F14);

  /// Surface des cartes (hsl 229 27% 12%).
  static const Color carte = Color(0xFF171A23);

  /// Bordures discrètes (hsl 228 25% 21%).
  static const Color bordure = Color(0xFF282E43);

  /// Texte secondaire (hsl 226 18% 62%).
  static const Color texteSecondaire = Color(0xFF8D95B0);

  /// Champs de saisie légèrement surélevés.
  static const Color champ = Color(0xFF1F2430);

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: cyan,
        onPrimary: Colors.white,
        secondary: bleu,
        onSecondary: fond,
        tertiary: violet,
        error: corail,
        onError: Colors.white,
        surface: carte,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: fond,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800),
        displayMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800),
        displaySmall: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800),
        headlineLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800),
        headlineSmall: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700),
        titleSmall: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontFamily: 'Inter', color: Colors.white),
        bodyMedium: TextStyle(fontFamily: 'Inter', color: Colors.white),
        bodySmall: TextStyle(fontFamily: 'Inter', color: texteSecondaire),
        labelLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Inter', color: texteSecondaire),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: fond,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        color: carte,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: bordure),
        ),
      ),
      dividerTheme: const DividerThemeData(color: bordure),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: carte,
        indicatorColor: cyan,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: champ,
        hintStyle: const TextStyle(color: texteSecondaire),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: bordure),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: bordure),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: cyan, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cyan,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cyan,
          side: const BorderSide(color: cyan),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        fillColor: WidgetStatePropertyAll(cyan),
        checkColor: WidgetStatePropertyAll(Colors.white),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: carte,
        contentTextStyle: TextStyle(color: Colors.white, fontFamily: 'Inter'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return base;
  }
}
