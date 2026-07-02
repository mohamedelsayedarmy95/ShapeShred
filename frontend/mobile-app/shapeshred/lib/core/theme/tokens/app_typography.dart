import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get display =>
      GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.bold);
  static TextStyle get headline =>
      GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold);
  static TextStyle get title =>
      GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600);
  static TextStyle get body =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal);
  static TextStyle get label =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get caption =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal);
}
