import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

abstract class AppTypography {
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 57,
          height: 64 / 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: AppTextColor.primary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 45,
          height: 52 / 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: AppTextColor.primary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: AppTextColor.primary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppTextColor.primary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppTextColor.primary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppTextColor.primary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: AppTextColor.primary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: AppTextColor.primary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppTextColor.primary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppTextColor.primary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppTextColor.primary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppTextColor.secondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: AppTextColor.primary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppTextColor.primary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppTextColor.primary,
        ),
      );
}
