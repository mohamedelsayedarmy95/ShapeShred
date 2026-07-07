import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';

/// Ultra Premium Dark Theme
/// Elegant dark mode with premium contrast and readability
class AppDarkTheme {
  AppDarkTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColorPalette.pureWhite,
        onPrimary: AppColorPalette.absoluteBlack,
        secondary: AppColorPalette.gray400,
        onSecondary: AppColorPalette.gray900,
        error: AppColorPalette.error,
        onError: AppColorPalette.pureWhite,
        surface: AppColorPalette.gray900,
        onSurface: AppColorPalette.pureWhite,
        outline: AppColorPalette.gray600,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColorPalette.gray900,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorPalette.gray900,
        foregroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColorPalette.pureWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColorPalette.gray800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColorPalette.gray200,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColorPalette.gray300,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColorPalette.gray400,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColorPalette.pureWhite,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColorPalette.gray200,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColorPalette.gray400,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorPalette.gray800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorPalette.gray600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorPalette.gray600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorPalette.pureWhite, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorPalette.error),
        ),
        labelStyle: const TextStyle(
          color: AppColorPalette.gray400,
        ),
        hintStyle: const TextStyle(
          color: AppColorPalette.gray500,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorPalette.pureWhite,
          foregroundColor: AppColorPalette.absoluteBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorPalette.pureWhite,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorPalette.pureWhite,
          side: const BorderSide(color: AppColorPalette.gray600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorPalette.gray900,
        selectedItemColor: AppColorPalette.pureWhite,
        unselectedItemColor: AppColorPalette.gray500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColorPalette.gray700,
        thickness: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColorPalette.pureWhite,
      ),
    );
  }
}
