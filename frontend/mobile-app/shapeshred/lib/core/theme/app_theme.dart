import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

/// Premium Black & White Theme
/// World-class minimalist design for ShapeShred
class AppTheme {
  AppTheme._();

  /// Light Theme (Primary - Black & White)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
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

      // Scaffold Background
      scaffoldBackgroundColor: AppColorPalette.pureWhite,

      // Typography
      textTheme: AppTypography.textTheme,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColorPalette.pureWhite,
        foregroundColor: AppColorPalette.gray900,
        titleTextStyle: AppTypography.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Elevated Button
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
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorPalette.absoluteBlack,
          side: const BorderSide(
            color: AppColorPalette.absoluteBlack,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorPalette.absoluteBlack,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: AppSpacing.space12,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorPalette.gray50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColorPalette.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColorPalette.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(
            color: AppColorPalette.absoluteBlack,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColorPalette.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColorPalette.gray400,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColorPalette.gray700,
        ),
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColorPalette.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          side: const BorderSide(color: AppColorPalette.gray200),
        ),
        shadowColor: Colors.transparent,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorPalette.pureWhite,
        selectedItemColor: AppColorPalette.absoluteBlack,
        unselectedItemColor: AppColorPalette.gray400,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColorPalette.gray200,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColorPalette.gray900,
        size: AppIconSize.m,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColorPalette.absoluteBlack,
        linearTrackColor: AppColorPalette.gray200,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColorPalette.gray50,
        selectedColor: AppColorPalette.absoluteBlack,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }

  /// Dark Theme (Optional - for future)
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColorPalette.pureWhite,
        onPrimary: AppColorPalette.absoluteBlack,
        secondary: AppColorPalette.gray300,
        onSecondary: AppColorPalette.absoluteBlack,
        surface: AppColorPalette.gray900,
        onSurface: AppColorPalette.pureWhite,
      ),
      scaffoldBackgroundColor: AppColorPalette.absoluteBlack,
    );
  }
}
