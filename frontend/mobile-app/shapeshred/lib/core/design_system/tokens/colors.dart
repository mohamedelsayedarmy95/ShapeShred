// ENHANCED COLOR SYSTEM WITH MATERIAL DESIGN 3 PRINCIPLES
// Semantic, accessible, and dynamic color tokens

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' show Brightness, ColorScheme;

/// SEMANTIC COLOR SYSTEM
// Based on Material Design 3 principles with premium refinements
class AppColors {
  // Core semantic roles - these should be used throughout the app
  static Color get primary => _getColorFromScheme(
        Color(0xFF6750A4), // Primary base
        Color(0xFFFFFFFF), // On primary
      );
  static Color get onPrimary => _getColorFromScheme(
        Colors.white,
        Colors.black,
      );

  static Color get secondary => _getColorFromScheme(
        Color(0xFF625B71), // Secondary base
        Colors.white,
      );
  static Color get onSecondary => _getColorFromScheme(
        Colors.white,
        Colors.black,
      );

  static Color get tertiary => _getColorFromScheme(
        Color(0xFF7D5260), // Tertiary accent
        Colors.white,
      );
  static Color get onTertiary => _getColorFromScheme(
        Colors.white,
        Colors.black,
      );

  static Color get error => _getColorFromScheme(
        Color(0xFFB3261E), // Error red
        Colors.white,
      );
  static Color get onError => _getColorFromScheme(
        Colors.white,
        Colors.black,
      );

  static Color get background => _getColorFromScheme(
        Color(0xFFFFFBFE), // Background
        Color(0xFF1C1B1F), // Dark background
      );
  static Color get onBackground => _getColorFromScheme(
        Color(0xFF1C1B1F), // On background
        Color(0xFFE6E1E5), // Light on background
      );

  static Color get surface => _getColorFromScheme(
        Color(0xFFFFFBFE), // Surface
        Color(0xFF1C1B1F), // Dark surface
      );
  static Color get onSurface => _getColorFromScheme(
        Color(0xFF1C1B1F), // On surface
        Color(0xFFE6E1E5), // Light on surface
      );

  static Color get surfaceVariant => _getColorFromScheme(
        Color(0xFFE7E0EC), // Surface variant
        Color(0xFF49454F), // Dark surface variant
      );
  static Color get onSurfaceVariant => _getColorFromScheme(
        Color(0xFF49454F), // On surface variant
        Color(0xFFCAC4D0), // Light on surface variant
      );

  static Color get outline => _getColorFromScheme(
        Color(0xFF79747E), // Outline
        Color(0xFF938F99), // Light outline
      );

  static Color get shadow => Colors.black54;

  // INVERSE COLORS FOR SPECIAL CASES
  static Color get inverseSurface => _getColorFromScheme(
        Color(0xFF1C1B1F), // Dark surface
        Color(0xFFFFFBFE), // Light surface
      );
  static Color get inverseOnSurface => _getColorFromScheme(
        Color(0xFFFFFBFE), // Light on surface
        Color(0xFF1C1B1F), // Dark on surface
      );

  // ACCENT COLORS FOR DATA VISUALIZATION
  static const List<Color> chartColors = [
    Color(0xFF6750A4), // Purple
    Color(0xFFC2185B), // Pink
    Color(0xFF018786),  // Teal
    Color(0xFF00695C),  // Green
    Color(0xFF8E24AA),  // Purple accent
    Color(0xFFD81B60),  // Pink accent
    Color(0xFF0097A7),  // Cyan
    Color(0xFF2E7D32),  // Green dark
  ];

  // HELPER METHOD FOR DYNAMIC THEME SUPPORT
  static Color _getColorFromScheme(Color lightColor, Color darkColor) {
    // In a real implementation, this would use MediaQuery/platform brightness
    // For now, we'll return light color as default - this should be connected
    // to theme service in actual usage
    return lightColor;
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

  // Dark theme grayscale (inverted)
  static const Color darkWhite = Color(0xFF111827);
  static const Color darkGray50 = Color(0xFF1F2937);
  static const Color darkGray100 = Color(0xFF374151);
  static const Color darkGray200 = Color(0xFF4B5563);
  static const Color darkGray300 = Color(0xFF6B7280);
  static const Color darkGray400 = Color(0xFF9CA3AF);
  static const Color darkGray500 = Color(0xFFD1D5DB);
  static const Color darkGray600 = Color(0xFFE5E7EB);
  static const Color darkGray700 = Color(0xFFF3F4F6);
  static const Color darkGray800 = Color(0xFFF9FAFB);
  static const Color darkGray900 = Color(0xFFFFFFFF);
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
        AppGreyses.darkWhite,
      );

  // HELPER METHOD FOR DYNAMIC THEME SUPPORT
  static Color _getColorFromScheme(Color lightColor, Color darkColor) {
    // In a real implementation, this would use MediaQuery/platform brightness
    return lightColor;
  }
}