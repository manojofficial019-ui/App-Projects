import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryMagenta = Color(0xFF8B00FF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentYellow = Color(0xFFFFEB3B);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentTeal = Color(0xFF009688);

  // Quest Panel Blue Transparent Colors (Brand Theme)
  static const Color questPanelBlueAccent = Color(0xFF1A73E8);
  static const Color questPanelBlueDark = Color(0xFF0D47A1);
  static const Color questPanelBlueLight = Color(0xFF42A5F5);
  static const Color questPanelBlueBorder = Color(0xFF64B5F6);

  // Brand Glacier Theme
  static const Color glacierLightBlue = Color(0xFFE3F2FD); // Light glacier blue for quest screen
  static const Color glacierDarkBlue = Color(0xFF0D47A1); // Dark glacier blue for panels
  static const Color glacierGreen = Color(0xFF1B5E20); // Dark green accent
  static const Color glacierCyan = Color(0xFF00BCD4); // Cyan/glacier cyan
  static const Color glacierWhite = Color(0xFFFAFAFA); // White with light effect

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: primaryMagenta,
        surface: cardBackground,
        background: darkBackground,
        error: accentRed,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMagenta,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
        ),
      ),
    );
  }
}

