// ENHANCED RADIUS SYSTEM
// Aligned with spacing system for consistent visual language

import 'package:flutter/material.dart';

/// PREMIUM BORDER RADIUS SYSTEM
// Consistent with 4px grid and semantic naming
class AppRadius {
  AppRadius._();

  // === RADIUS SCALE (aligned with 4px grid) ===
  static const double none = 0.0;
  static const double xs = 2.0; // 0.5
  static const double sm = 4.0; // 1.0
  static const double md = 6.0; // 1.5
  static const double lg = 8.0; // 2.0
  static const double xl = 10.0; // 2.5
  static const double xxl = 12.0; // 3.0
  static const double xxxl = 14.0; // 3.5
  static const double xxxxl = 16.0; // 4.0

  // Specialized radii
  static const double pill = 50.0; // For pill-shaped elements
  static const double circle =
      50.0; // For circular elements (will be overridden by width/height)
  static const double mega = 24.0; // Extra large radius
  static const double giga = 32.0; // Giant radius

  // Legacy names for backward compatibility (deprecated)
  // These map to the new semantic system
  static const double radiusTiny = xs;
  static const double radiusSmall = sm;
  static const double radiusMedium = md;
  static const double radiusLarge = lg;
  static const double radiusXL = xl;
  static const double radiusXXL = xxl;
  static const double radiusXXXL = xxxl;
  static const double radiusXXXXL = xxxxl;
  static const double radiusPill = pill;
  static const double radiusCircle = circle;
}

// Border utilities for consistent stroke widths
class AppBorderWidth {
  AppBorderWidth._();

  static const double hairline = 0.5;
  static const double thin = 1.0;
  static const double regular = 2.0;
  static const double thick = 3.0;
  static const double heavy = 4.0;
}

// Border style utilities
// Note: Flutter only supports BorderStyle.none and BorderStyle.solid
// Other CSS border styles (dashed, dotted, etc.) are not supported
class AppBorderStyle {
  AppBorderStyle._();

  static const BorderStyle solid = BorderStyle.solid;
  // static const BorderStyle dashed = BorderStyle.dashed; // Not supported in Flutter
  // static const BorderStyle dotted = BorderStyle.dotted; // Not supported in Flutter
  // static const BorderStyle double = BorderStyle.double; // Not supported in Flutter
  // static const BorderStyle groove = BorderStyle.groove; // Not supported in Flutter
  // static const BorderStyle ridge = BorderStyle.ridge; // Not supported in Flutter
  // static const BorderStyle inset = BorderStyle.inset; // Not supported in Flutter
  // static const BorderStyle outset = BorderStyle.outset; // Not supported in Flutter
  static const BorderStyle none = BorderStyle.none;
  // static const BorderStyle hidden = BorderStyle.hidden; // Not supported in Flutter
}

// Edge insets helpers for consistent padding
class AppInsets {
  AppInsets._();

  static const EdgeInsets none = EdgeInsets.zero;

  // Uniform
  static const EdgeInsets xs = EdgeInsets.all(2.0);
  static const EdgeInsets sm = EdgeInsets.all(4.0);
  static const EdgeInsets md = EdgeInsets.all(6.0);
  static const EdgeInsets lg = EdgeInsets.all(8.0);
  static const EdgeInsets xl = EdgeInsets.all(10.0);
  static const EdgeInsets xxl = EdgeInsets.all(12.0);

  // Horizontal only
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: 2.0);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: 4.0);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: 6.0);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: 10.0);
  static const EdgeInsets horizontalXxl =
      EdgeInsets.symmetric(horizontal: 12.0);

  // Vertical only
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: 2.0);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: 4.0);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: 6.0);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: 10.0);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: 12.0);

  // Special combinations
  static const EdgeInsets insetXs = EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0);
  static const EdgeInsets insetSm = EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0);
  static const EdgeInsets insetMd = EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0);
  static const EdgeInsets insetLg = EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0);
  static const EdgeInsets insetXl = EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
  static const EdgeInsets insetXxl =
      EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0);

  // Asymmetric common patterns
  static const EdgeInsets insetHorizontalXs =
      EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0);
  static const EdgeInsets insetHorizontalSm =
      EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0);
  static const EdgeInsets insetHorizontalMd =
      EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0);
  static const EdgeInsets insetHorizontalLg =
      EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0);
  static const EdgeInsets insetHorizontalXl =
      EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0);
  static const EdgeInsets insetHorizontalXxl =
      EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0);

  static const EdgeInsets insetVerticalXs =
      EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0);
  static const EdgeInsets insetVerticalSm =
      EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0);
  static const EdgeInsets insetVerticalMd =
      EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0);
  static const EdgeInsets insetVerticalLg =
      EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0);
  static const EdgeInsets insetVerticalXl =
      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0);
  static const EdgeInsets insetVerticalXxl =
      EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0);
}

// Corner radius specific utilities
class AppBorderRadius {
  AppBorderRadius._();

  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius xs = BorderRadius.all(Radius.circular(2.0));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius md = BorderRadius.all(Radius.circular(6.0));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(10.0));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius xxxl = BorderRadius.all(Radius.circular(14.0));
  static const BorderRadius xxxxl = BorderRadius.all(Radius.circular(16.0));

  // Direction-specific radii
  static BorderRadius onlyTopLeft({double radius = 4.0}) =>
      BorderRadius.only(topLeft: Radius.circular(radius));
  static BorderRadius onlyTopRight({double radius = 4.0}) =>
      BorderRadius.only(topRight: Radius.circular(radius));
  static BorderRadius onlyBottomLeft({double radius = 4.0}) =>
      BorderRadius.only(bottomLeft: Radius.circular(radius));
  static BorderRadius onlyBottomRight({double radius = 4.0}) =>
      BorderRadius.only(bottomRight: Radius.circular(radius));

  static BorderRadius topOnly({double radius = 4.0}) =>
      BorderRadius.vertical(top: Radius.circular(radius));
  static BorderRadius bottomOnly({double radius = 4.0}) =>
      BorderRadius.vertical(bottom: Radius.circular(radius));
  static BorderRadius leftOnly({double radius = 4.0}) =>
      BorderRadius.horizontal(left: Radius.circular(radius));
  static BorderRadius rightOnly({double radius = 4.0}) =>
      BorderRadius.horizontal(right: Radius.circular(radius));

  // Elliptical radii
  static BorderRadius ellipticalXs =
      const BorderRadius.all(Radius.elliptical(2.0, 4.0));
  static BorderRadius ellipticalSm =
      const BorderRadius.all(Radius.elliptical(4.0, 8.0));
  static BorderRadius ellipticalMd =
      const BorderRadius.all(Radius.elliptical(6.0, 12.0));
  static BorderRadius ellipticalLg =
      const BorderRadius.all(Radius.elliptical(8.0, 16.0));
}
