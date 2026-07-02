import 'package:flutter/material.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppSemanticColors.primary,
        surface: AppSemanticColors.surface,
        error: AppSemanticColors.error,
      ),
      scaffoldBackgroundColor: AppSemanticColors.background,
      textTheme: TextTheme(
        displayLarge:
            AppTypography.display.copyWith(color: AppSemanticColors.primary),
        headlineMedium:
            AppTypography.headline.copyWith(color: AppSemanticColors.primary),
        titleMedium:
            AppTypography.title.copyWith(color: AppSemanticColors.primary),
        bodyLarge:
            AppTypography.body.copyWith(color: AppSemanticColors.primary),
        bodyMedium:
            AppTypography.body.copyWith(color: AppSemanticColors.primary),
        labelLarge:
            AppTypography.label.copyWith(color: AppSemanticColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.grey200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.black, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.grey400),
        labelStyle: const TextStyle(color: AppColors.grey700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          textStyle: AppTypography.label.copyWith(fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.white,
        surface: AppColors.black,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.black,
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: AppColors.white),
        headlineMedium: AppTypography.headline.copyWith(color: AppColors.white),
        titleMedium: AppTypography.title.copyWith(color: AppColors.white),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.white),
        bodyMedium: AppTypography.body.copyWith(color: AppColors.white),
        labelLarge: AppTypography.label.copyWith(color: AppColors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.grey700, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.white, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.grey600),
        labelStyle: const TextStyle(color: AppColors.grey400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          textStyle: AppTypography.label.copyWith(fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          elevation: 0,
        ),
      ),
    );
  }
}
