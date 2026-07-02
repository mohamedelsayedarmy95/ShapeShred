import 'package:flutter/material.dart';

/// 🏛️ ShapeShred Monochromatic Color Palette
abstract class AppColorPalette {
  static const Color pureWhite = Color(0xFFFFFFFF);

  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  /// Black is reserved for shadows, borders, and micro-details ONLY (≤2%)
  static const Color absoluteBlack = Color(0xFF000000);
}

abstract class AppSemanticColors {
  static const Color success = AppColorPalette.gray900;
  static const Color warning = AppColorPalette.gray700;
  static const Color danger = AppColorPalette.gray800;
  static const Color info = AppColorPalette.gray600;
}

abstract class AppSurfaceLevel {
  static const Color background = AppColorPalette.pureWhite;
  static const Color elevated = AppColorPalette.gray50;
  static const Color pressed = AppColorPalette.gray100;
  static const Color dragged = AppColorPalette.gray200;
  static const Color selected = AppColorPalette.gray300;
}

abstract class AppTextColor {
  static const Color primary = AppColorPalette.gray900;
  static const Color secondary = AppColorPalette.gray700;
  static const Color tertiary = AppColorPalette.gray500;
  static const Color disabled = AppColorPalette.gray400;
  static const Color inverse = AppColorPalette.pureWhite;
  static const Color inverseSecondary = AppColorPalette.gray300;
}
