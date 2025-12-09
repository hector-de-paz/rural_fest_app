import 'package:flutter/material.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // 🎨 COLOR PALETTE - EDIT THESE TO CHANGE APP APPEARANCE
  // ---------------------------------------------------------------------------

  // Main Brand Colors
  static const Color primaryColor = Color(0xFF4CAF50); // Green (Nature/Rural)

  static const Color secondaryColor = Color(
    0xFFFF9800,
  ); // Orange (Festive/Highlight)

  // Background Colors
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Light Grey

  static const Color cardColor = Colors.white;

  static const Color bottomNavBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(
    0xFF212121,
  ); // Dark Grey (Main content)
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Medium Grey (Subtitles)
  static const Color textInverse =
      Colors.white; // Text on primary buttons/appbar

  // Status Colors
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color successColor = Color(0xFF388E3C); // Dark Green

  // Input Fields
  static const Color inputFillColor = Color(0xFFFAFAFA);
  static const Color inputBorderColor = Color(0xFFE0E0E0);

  // ---------------------------------------------------------------------------
  // THEME DATA GENERATOR
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: cardColor,
        onPrimary: textInverse,
        onSecondary: textInverse,
        onSurface: textPrimary,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: scaffoldBackgroundColor,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textInverse,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textInverse,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textInverse),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),

        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textInverse,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: textInverse,
        elevation: 4,
      ),

      // Navigation Bar Theme (Bottom Bar)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bottomNavBackground,
        indicatorColor: primaryColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor);
          }
          return const IconThemeData(color: textSecondary);
        }),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textSecondary, fontSize: 14),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),
    );
  }
}
