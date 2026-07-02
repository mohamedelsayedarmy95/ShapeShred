import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/radius.dart';
import 'shapeshred_theme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColorPalette.gray900,
      scaffoldBackgroundColor: AppSurfaceLevel.background,
      textTheme: AppTypography.textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColorPalette.gray900,
        secondary: AppColorPalette.gray700,
        surface: AppSurfaceLevel.background,
        onSurface: AppTextColor.primary,
        error: AppColorPalette.gray800, // Monochromatic danger
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppSurfaceLevel.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTextColor.primary),
        titleTextStyle: TextStyle(
          color: AppTextColor.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorPalette.gray900,
          foregroundColor: AppColorPalette.pureWhite,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusPill),
          ),
          elevation: 0,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTextColor.primary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColorPalette.gray300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusPill),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppSurfaceLevel.elevated,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
          borderSide: const BorderSide(color: AppColorPalette.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
          borderSide: const BorderSide(color: AppColorPalette.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
          borderSide:
              const BorderSide(color: AppColorPalette.gray900, width: 2),
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppTextColor.tertiary,
        ),
      ),
      extensions: const [
        ShapeShredThemeExtension(
          workoutCardElevation: 2.0,
          modalElevation: 16.0,
          cardBackground: AppSurfaceLevel.elevated,
        ),
      ],
    );
  }
}
