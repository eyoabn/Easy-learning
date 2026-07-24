import 'package:flutter/material.dart';

class AppTheme {
  // Brand Palette
  static const primaryColor = Color(0xFF4C7EFF);
  static const accentColor = Color(0xFF00D9A3);
  static const darkBackgroundColor = Color(0xFF0D1117);
  static const darkCardColor = Color(0xFF161B22);
  static const darkSurfaceColor = Color(0xFF21262D);
  static const darkBorderColor = Color(0xFF30363D);
  static const textMuted = Color(0xFF8B949E);
  static const alertRed = Color(0xFFF85149);
  static const alertOrange = Color(0xFFD29922);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: darkCardColor,
        background: darkBackgroundColor,
        error: alertRed,
      ),
      cardTheme: CardTheme(
        color: darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceColor,
        side: const BorderSide(color: darkBorderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
      ),
    );
  }
}
