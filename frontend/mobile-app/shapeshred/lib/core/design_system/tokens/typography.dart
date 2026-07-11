// ENHANCED TYPOGRAPHY SYSTEM
// Based on a harmonious scale with proper hierarchy and responsiveness

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PREMIUM TYPOGRAPHY SYSTEM
// Using Inter var variable font for maximum flexibility and performance
class AppTypography {
  AppTypography._();

  // Type scale based on 4px grid with 1.125 ratio (major third)
  // Base size: 16px (1.0 rem)

  // Display styles - for short, important text
  static final TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 57.0, // 3.6625rem
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static final TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 45.0, // 2.8125rem
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.16,
  );

  static final TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 36.0, // 2.25rem
    fontWeight: FontWeight.w400,
    letterSpacing: -0.15,
    height: 1.2,
  );

  // Headline styles - for longer-form headings
  static final TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32.0, // 2.0rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.28,
  );

  static final TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28.0, // 1.75rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.28,
  );

  static final TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24.0, // 1.5rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.28,
  );

  // Title styles - for UI elements like cards, sections
  static final TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22.0, // 1.375rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.36,
  );

  static final TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16.0, // 1.0rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14.0, // 0.875rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body styles - for long-form reading
  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16.0, // 1.0rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14.0, // 0.875rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12.0, // 0.75rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label styles - for UI components like buttons, chips
  static final TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14.0, // 0.875rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12.0, // 0.75rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static final TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11.0, // 0.6875rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // CONVENIENT STATIC ACCESSORS (for backward compatibility)
  static TextStyle get display1 => displayLarge;
  static TextStyle get display2 => displayMedium;
  static TextStyle get display3 => displaySmall;
  static TextStyle get headline1 => headlineLarge;
  static TextStyle get headline2 => headlineMedium;
  static TextStyle get headline3 => headlineSmall;
  static TextStyle get subtitle1 => titleLarge;
  static TextStyle get subtitle2 => titleMedium;
  static TextStyle get body1 => bodyLarge;
  static TextStyle get body2 => bodyMedium;
  static TextStyle get caption => bodySmall;
  static TextStyle get button => labelLarge;
  static TextStyle get overline => labelSmall;

  // DYNAMIC TYPE SCALE HELPER
  static TextStyle applyFontSizeToStyle(TextStyle baseStyle, double fontSize) {
    return baseStyle.copyWith(
      fontSize: fontSize,
      height:
          (baseStyle.height ?? 1.0) * (baseStyle.fontSize ?? 14.0) / fontSize,
    );
  }
}
