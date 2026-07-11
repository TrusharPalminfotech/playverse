import 'package:flutter/material.dart';

class AppColors {
  static const Color obsidianBgStart = Color(0xFF0A0D14);
  static const Color obsidianBgEnd = Color(0xFF141923);

  static const Color accentNeonGreen = Color(0xFFCCFF00); // Electric lime green
  static const Color accentNeonCyan = Color(0xFF00E5FF); // High-tech cyber cyan
  static const Color accentBlue = Color(0xFF2979FF);

  static const Color glassCardBg = Color(
    0x0DFFFFFF,
  ); // Semi-transparent glass background
  static const Color glassCardBorder = Color(0x1AFFFFFF); // Soft white border

  static const Color textPrimary = Color(0xFFF5F6F9);
  static const Color textSecondary = Color(0xFF8E9AA8);
  static const Color textMuted = Color(0xFF5D6B7C);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidianBgStart,
      primaryColor: AppColors.accentNeonGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentNeonGreen,
        secondary: AppColors.accentNeonCyan,
        surface: AppColors.glassCardBg,
      ),
      fontFamily: 'Roboto', // Default fallback
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(
          0x33000000,
        ), // Equivalent to Colors.black.withOpacity(0.2)
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.glassCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.glassCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.accentNeonCyan,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  static BoxDecoration get screenGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.obsidianBgStart, AppColors.obsidianBgEnd],
      ),
    );
  }
}
