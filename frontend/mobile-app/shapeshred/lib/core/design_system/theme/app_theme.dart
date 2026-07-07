import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

/// Premium Material Theme
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      colorScheme: const ColorScheme.light(
        primary: AppColorPalette.absoluteBlack,
        onPrimary: AppColorPalette.pureWhite,
        secondary: AppColorPalette.gray700,
        onSecondary: AppColorPalette.pureWhite,
        surface: AppColorPalette.pureWhite,
        onSurface: AppColorPalette.gray900,
        error: AppColorPalette.error,
        onError: AppColorPalette.pureWhite,
      ),

      scaffoldBackgroundColor: AppColorPalette.pureWhite,
      textTheme: _buildTextTheme(),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColorPalette.pureWhite,
        foregroundColor: AppColorPalette.gray900,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorPalette.absoluteBlack,
          foregroundColor: AppColorPalette.pureWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorPalette.gray50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColorPalette.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColorPalette.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(
            color: AppColorPalette.absoluteBlack,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColorPalette.error),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColorPalette.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          side: const BorderSide(color: AppColorPalette.gray200),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      bodyMedium: AppTypography.bodyMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodySmall: AppTypography.bodySmall,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleMedium: AppTypography.titleMedium,
      labelLarge: AppTypography.labelLarge,
      labelSmall: AppTypography.labelSmall,
    );
  }
}
