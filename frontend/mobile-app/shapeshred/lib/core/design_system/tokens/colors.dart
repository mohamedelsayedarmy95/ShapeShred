// ENHANCED COLOR SYSTEM WITH MATERIAL DESIGN 3 PRINCIPLES
// Semantic, accessible, and dynamic color tokens

import 'package:flutter/material.dart';
import 'package:shapeshred/core/services/theme_service.dart';

/// SEMANTIC COLOR SYSTEM
// Ultra-premium palette: electric violet + teal accents over deep obsidian
// surfaces in dark mode, with a clean high-contrast light mode counterpart.
class AppColors {
  // Core semantic roles - these should be used throughout the app
  static Color get primary => _getColorFromScheme(
        Color(0xFF6D28D9), // Electric violet (light)
        Color(0xFF8B5CF6), // Electric violet, brighter for pop on black
      );
  static Color get onPrimary => _getColorFromScheme(
        Colors.white,
        Colors.white,
      );

  static Color get secondary => _getColorFromScheme(
        Color(0xFF0D9488), // Electric teal (light)
        Color(0xFF2DD4BF), // Electric teal, brighter for dark
      );
  static Color get onSecondary => _getColorFromScheme(
        Colors.white,
        Color(0xFF042F2E),
      );

  static Color get tertiary => _getColorFromScheme(
        Color(0xFF16A34A), // Performance lime-green (light)
        Color(0xFF4ADE80), // Performance lime-green (dark)
      );
  static Color get onTertiary => _getColorFromScheme(
        Colors.white,
        Color(0xFF052E16),
      );

  static Color get error => _getColorFromScheme(
        Color(0xFFDC2626), // Error red (light)
        Color(0xFFF87171), // Error red, brighter for dark
      );
  static Color get onError => _getColorFromScheme(
        Colors.white,
        Color(0xFF450A0A),
      );

  static Color get background => _getColorFromScheme(
        Color(0xFFFAFAFC), // Background (light)
        Color(0xFF0B0B10), // Obsidian background (dark)
      );
  static Color get onBackground => _getColorFromScheme(
        Color(0xFF16161D), // On background (light)
        Color(0xFFEDEDF2), // On background (dark)
      );

  static Color get surface => _getColorFromScheme(
        Color(0xFFFFFFFF), // Surface (light)
        Color(0xFF15151B), // Elevated obsidian surface (dark)
      );
  static Color get onSurface => _getColorFromScheme(
        Color(0xFF16161D), // On surface (light)
        Color(0xFFEDEDF2), // On surface (dark)
      );

  static Color get surfaceVariant => _getColorFromScheme(
        Color(0xFFF0EEF7), // Surface variant (light)
        Color(0xFF1F1F27), // Surface variant (dark)
      );
  static Color get onSurfaceVariant => _getColorFromScheme(
        Color(0xFF49454F), // On surface variant (light)
        Color(0xFFB8B5C0), // On surface variant (dark)
      );

  static Color get outline => _getColorFromScheme(
        Color(0xFFE0DDE8), // Outline (light)
        Color(0xFF2E2E38), // Outline (dark)
      );

  static Color get shadow => Colors.black54;

  static Color get divider => _getColorFromScheme(
        Color(0xFFEDEBF2), // Divider (light)
        Color(0xFF232329), // Divider (dark)
      );

  static Color get warning => _getColorFromScheme(
        Color(0xFFD97706), // Amber (light)
        Color(0xFFFBBF24), // Amber (dark)
      );

  static Color get success => tertiary;

  static Color get info => secondary;

  // INVERSE COLORS FOR SPECIAL CASES
  static Color get inverseSurface => _getColorFromScheme(
        Color(0xFF0B0B10), // Dark surface
        Color(0xFFFFFFFF), // Light surface
      );
  static Color get inverseOnSurface => _getColorFromScheme(
        Color(0xFFEDEDF2), // Light-on-dark text
        Color(0xFF16161D), // Dark-on-light text
      );

  // HERO GRADIENT - violet -> teal, used for CTAs, hero cards, progress rings
  static const List<Color> heroGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF2DD4BF),
  ];

  // ACCENT COLORS FOR DATA VISUALIZATION
  static const List<Color> chartColors = [
    Color(0xFF8B5CF6), // Violet
    Color(0xFF2DD4BF), // Teal
    Color(0xFF4ADE80), // Lime
    Color(0xFFF472B6), // Pink
    Color(0xFFFBBF24), // Amber
    Color(0xFF60A5FA), // Blue
    Color(0xFFF87171), // Red
    Color(0xFFA78BFA), // Violet light
  ];

  // HELPER METHOD FOR DYNAMIC THEME SUPPORT
  static Color _getColorFromScheme(Color lightColor, Color darkColor) {
    return ThemeService.isDarkMode ? darkColor : lightColor;
  }
}

/// PROFESSIONAL GRAYSCALE SCALE
// For cases where neutral grays are needed (text, dividers, etc.)
class AppGreyscale {
  // Light theme grayscale
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Dark theme grayscale (for text on dark backgrounds - should be LIGHT colors)
  static const Color darkWhite = Color(0xFFFFFFFF); // White
  static const Color darkGray50 = Color(0xFFF9FAFB); // grayscale 50
  static const Color darkGray100 = Color(0xFFF3F4F6); // grayscale 100
  static const Color darkGray200 = Color(0xFFE5E7EB); // grayscale 200
  static const Color darkGray300 = Color(0xFFD1D5DB); // grayscale 300
  static const Color darkGray400 = Color(0xFF9CA3AF); // grayscale 400
  static const Color darkGray500 = Color(0xFF6B7280); // grayscale 500
  static const Color darkGray600 = Color(0xFF4B5563); // grayscale 600
  static const Color darkGray700 = Color(0xFF374151); // grayscale 700
  static const Color darkGray800 = Color(0xFF1F2937); // grayscale 800
  static const Color darkGray900 = Color(0xFF111827); // grayscale 900
}

/// TEXT COLOR SYSTEM
// Semantic text colors for different contexts
class AppTextColors {
  // Primary text - main content
  static Color get primary => _getColorFromScheme(
        AppGreyscale.gray900,
        AppGreyscale.darkGray50,
      );

  // Secondary text - less prominent content
  static Color get secondary => _getColorFromScheme(
        AppGreyscale.gray600,
        AppGreyscale.darkGray400,
      );

  // Tertiary text - hints, placeholders, disabled
  static Color get tertiary => _getColorFromScheme(
        AppGreyscale.gray400,
        AppGreyscale.darkGray300,
      );

  // Disabled text
  static Color get disabled => _getColorFromScheme(
        AppGreyscale.gray300,
        AppGreyscale.darkGray200,
      );

  // Inverse text (for dark backgrounds)
  static Color get inverse => _getColorFromScheme(
        AppGreyscale.white,
        AppGreyscale.darkWhite,
      );

  // HELPER METHOD FOR DYNAMIC THEME SUPPORT
  static Color _getColorFromScheme(Color lightColor, Color darkColor) {
    return ThemeService.isDarkMode ? darkColor : lightColor;
  }
}

/// Compatibility alias for the pre-redesign palette. Kept const so old call
/// sites that require compile-time constants keep compiling; new code should
/// use [AppGreyscale] / [AppColors] instead.
class AppColorPalette {
  AppColorPalette._();

  static const Color absoluteBlack = Color(0xFF121212);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static const Color gray900 = Color(0xFF121212);
  static const Color gray800 = Color(0xFF1E1E1E);
  static const Color gray700 = Color(0xFF2D2D2D);
  static const Color gray600 = Color(0xFF3D3D3D);
  static const Color gray500 = Color(0xFF4D4D4D);
  static const Color gray400 = Color(0xFF6D6D6D);
  static const Color gray300 = Color(0xFF8D8D8D);
  static const Color gray200 = Color(0xFFADADAD);
  static const Color gray100 = Color(0xFFCDCDCD);
  static const Color gray50 = Color(0xFFEDEDED);

  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
}

/// Compatibility alias for the pre-redesign text color palette. Kept const
/// for the same reason as [AppColorPalette]; new code should use
/// [AppTextColors] instead.
class AppTextColor {
  AppTextColor._();

  static const Color primary = Color(0xFF121212);
  static const Color secondary = Color(0xFF4D4D4D);
  static const Color tertiary = Color(0xFF6D6D6D);
  static const Color disabled = Color(0xFF8D8D8D);
  static const Color inverse = Color(0xFFFFFFFF);
}