import 'package:flutter/material.dart';

class AppColorPalette {
  static const Color absoluteBlack = Color(0xFF000000);
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
}

class AppSurfaceLevel {
  static const Color background = AppColorPalette.pureWhite;
  static const Color elevated = AppColorPalette.gray50;
  static const Color overlay = AppColorPalette.gray100;
}

class AppTextColor {
  static const Color primary = AppColorPalette.gray900;
  static const Color secondary = AppColorPalette.gray500;
  static const Color disabled = AppColorPalette.gray300;
}

class AppSemanticColors {
  static const Color primary = AppColorPalette.absoluteBlack;
  static const Color surface = AppColorPalette.pureWhite;
  static const Color background = AppColorPalette.pureWhite;
  static const Color error = Color(0xFFDC2626);
}