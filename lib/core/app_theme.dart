import 'package:flutter/material.dart';

/// Thème Material 3 de l'application, inspiré de l'identité visuelle
/// UNICEF (cyan et bleu) avec des accents chaleureux pour les adolescents.
class AppTheme {
  static const Color cyan = Color(0xFF1CABE2);
  static const Color bleu = Color(0xFF374EA2);
  static const Color jaune = Color(0xFFFECB00);
  static const Color corail = Color(0xFFFF6B4A);
  static const Color violet = Color(0xFF7B5AC5);
  static const Color vert = Color(0xFF2FBF71);
  static const Color fondClair = Color(0xFFF5F9FC);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cyan,
          primary: cyan,
          secondary: jaune,
          tertiary: violet,
          surface: fondClair,
        ),
        scaffoldBackgroundColor: fondClair,
        appBarTheme: const AppBarTheme(
          backgroundColor: cyan,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8E6F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: cyan, width: 2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      );
}
