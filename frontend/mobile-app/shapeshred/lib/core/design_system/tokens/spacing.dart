// ENHANCED SPACING SYSTEM
// Semantic spacing with 4px grid foundation and responsive considerations

/// PREMIUM SPACING SYSTEM
// Based on 4px grid with semantic naming for maintainability
class AppSpacing {
  AppSpacing._();

  // === CORE SPACING VALUES (4px grid) ===
  // Base units for consistent spacing throughout the app

  // XXS - Extra extra small
  static const double xxsmall = 2.0;   // 0.5

  // XS - Extra small
  static const double xsmall = 4.0;    // 1.0

  // SM - Small
  static const double small = 6.0;     // 1.5

  // MD - Medium
  static const double medium = 8.0;    // 2.0

  // LG - Large
  static const double large = 12.0;    // 3.0

  // XL - Extra large
  static const double xlarge = 16.0;   // 4.0

  // XXL - Extra extra large
  static const double xxlarge = 20.0;  // 5.0

  // XXXL - Extra extra extra large
  static const double xxxlarge = 24.0; // 6.0

  // XXXXL - 4x large
  static const double xxxxlarge = 28.0; // 7.0

  // XXXXXL - 5x large
  static const double xxxxxlarge = 32.0; // 8.0

  // XXXXXXL - 6x large
  static const double xxxxxxlarge = 36.0; // 9.0

  // XXXXXXXL - 7x large
  static const double xxxxxxxlarge = 40.0; // 10.0

  // XXXXXXXXL - 8x large
  static const double xxxxxxxxlarge = 44.0; // 11.0

  // XXXXXXXXXL - 9x large
  static const double xxxxxxxxxlarge = 48.0; // 12.0

  // === SEMANTIC SPACING (RECOMMENDED FOR USE) ===
  // These should be preferred in most cases as they convey intent

  // Layout spacing
  static const double layoutNone = 0.0;
  static const double layoutXs = 4.0;    // For tight spaces
  static const double layoutSm = 8.0;    // Standard small spacing
  static const double layoutMd = 12.0;   // Standard medium spacing
  static const double layoutLg = 16.0;   // Standard large spacing
  static const double layoutXl = 20.0;   // Extra large spacing
  static const double layoutXxl = 24.0;  // Double extra large
  static const double layoutXxxl = 28.0; // Triple extra large
  static const double layoutXxxxl = 32.0; // Quadruple extra large

  // Component spacing
  static const double componentNone = 0.0;
  static const double componentXs = 4.0;     // Tiny component gaps
  static const double componentSm = 6.0;     // Small component gaps
  static const double componentMd = 8.0;     // Standard component gap
  static const double componentLg = 12.0;    // Large component gap
  static const double componentXl = 16.0;    // Extra large component gap
  static const double componentXxl = 20.0;   // XXL component gap

  // Text spacing
  static const double textNone = 0.0;
  static const double textXs = 2.0;      // Tight letter/word spacing
  static const double textSm = 4.0;      // Small text spacing
  static const double textMd = 6.0;      // Medium text spacing
  static const double textLg = 8.0;      // Large text spacing
  static const double textXl = 10.0;     // Extra large text spacing

  // Icon spacing
  static const double iconNone = 0.0;
  static const double iconXs = 2.0;      // Icon padding
  static const double iconSm = 4.0;      // Small icon spacing
  static const double iconMd = 6.0;      // Medium icon spacing
  static const double iconLg = 8.0;      // Large icon spacing

  // === LAYOUT SPECIFIC SPACING ===
  // Screen and container padding

  // Screen padding (horizontal)
  static const double screenPaddingNone = 0.0;
  static const double screenPaddingXs = 8.0;
  static const double screenPaddingSm = 12.0;
  static const double screenPaddingMd = 16.0;
  static const double screenPaddingLg = 20.0;
  static const double screenPaddingXl = 24.0;
  static const double screenPaddingXxl = 28.0;

  // Screen padding (vertical)
  static const double screenPaddingVerticalNone = 0.0;
  static const double screenPaddingVerticalXs = 8.0;
  static const double screenPaddingVerticalSm = 12.0;
  static const double screenPaddingVerticalMd = 16.0;
  static const double screenPaddingVerticalLg = 20.0;
  static const double screenPaddingVerticalXl = 24.0;
  static const double screenPaymentVerticalXxl = 28.0;

  // Container padding
  static const double containerPaddingNone = 0.0;
  static const double containerPaddingXs = 8.0;
  static const double containerPaddingSm = 12.0;
  static const double containerPaddingMd = 16.0;
  static const double containerPaddingLg = 20.0;
  static const double containerPaddingXl = 24.0;
  static const double containerPaddingXxl = 28.0;

  // === COMPONENT SPECIFIC SPACING ===
  // Button padding
  static const double buttonPaddingVerticalNone = 0.0;
  static const double buttonPaddingVerticalXs = 6.0;
  static const double buttonPaddingVerticalSm = 8.0;
  static const double buttonPaddingVerticalMd = 10.0;
  static const double buttonPaddingVerticalLg = 12.0;
  static const double buttonPaddingVerticalXl = 14.0;
  static const double buttonPaddingVerticalXxl = 16.0;

  static const double buttonPaddingHorizontalNone = 0.0;
  static const double buttonPaddingHorizontalXs = 8.0;
  static const double buttonPaddingHorizontalSm = 12.0;
  static const double buttonPaddingHorizontalMd = 16.0;
  static const double buttonPaddingHorizontalLg = 20.0;
  static const double buttonPaddingHorizontalXl = 24.0;
  static const double buttonPaddingHorizontalXxl = 28.0;

  // Input field padding
  static const double inputPaddingVerticalNone = 0.0;
  static const double inputPaddingVerticalXs = 8.0;
  static const double inputPaddingVerticalSm = 10.0;
  static const double inputPaddingVerticalMd = 12.0;
  static const double inputPaddingVerticalLg = 14.0;
  static const double inputPaddingVerticalXl = 16.0;
  static const double inputPaddingVerticalXxl = 18.0;

  static const double inputPaddingHorizontalNone = 0.0;
  static const double inputPaddingHorizontalXs = 8.0;
  static const double inputPaddingHorizontalSm = 12.0;
  static const double inputPaddingHorizontalMd = 16.0;
  static const double inputPaddingHorizontalLg = 20.0;
  static const double inputPaddingHorizontalXl = 24.0;
  static const double inputPaddingHorizontalXxl = 28.0;

  // Card padding
  static const double cardPaddingNone = 0.0;
  static const double cardPaddingXs = 8.0;
  static const double cardPaddingSm = 12.0;
  static const double cardPaddingMd = 16.0;
  static const double cardPaddingLg = 20.0;
  static const double cardPaddingXl = 24.0;
  static const double cardPaddingXxl = 28.0;

  // Divider thickness
  static const double dividerThicknessHairline = 0.5;
  static const double dividerThicknessThin = 1.0;
  static const double dividerThicknessNormal = 1.5;
  static const double dividerThicknessThick = 2.0;

  // Border radius
  static const double borderRadiusNone = 0.0;
  static const double borderRadiusXs = 2.0;
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 6.0;
  static const double borderRadiusLg = 8.0;
  static const double borderRadiusXl = 10.0;
  static const double borderRadiusXxl = 12.0;
  static const double borderRadiusXxxl = 14.0;
  static const double borderRadiusXxxxl = 16.0;

  // Icon sizes
  static const double iconSizeXxs = 12.0;
  static const double iconSizeXs = 14.0;
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 18.0;
  static const double iconSizeLg = 20.0;
  static const double iconSizeXl = 22.0;
  static const double iconSizeXxl = 24.0;
  static const double iconSizeXxxl = 26.0;
  static const double iconSizeXxxxl = 28.0;
  static const double iconSizeXxxxxl = 30.0;
  static const double iconSizeXxxxxxl = 32.0;
  static const double iconSizeXxxxxx = 36.0;
  static const double iconSizeXxxxxxx = 40.0;
  static const double iconSizeXxxxxxxx = 44.0;
  static const double iconSizeXxxxxxxxx = 48.0;

  // === DEPRECATED ALIASES (for backward compatibility) ===
  // These map to the new semantic system

  // Screen padding
  static const double screenPadding = screenPaddingMd;
  static const double screenPaddingSmall = screenPaddingSm;
  static const double screenPaddingLarge = screenPaddingLg;

  // Base spacing
  static const double space2 = xxsmall;
  static const double space4 = xsmall;
  static const double space6 = small;
  static const double space8 = medium;
  static const double space12 = large;
  static const double space16 = xlarge;
  static const double space20 = xxlarge;
  static const double space24 = xxxlarge;
  static const double space28 = xxxxlarge;
  static const double space32 = xxxxxlarge;
  static const double space36 = xxxxxxlarge;
  static const double space40 = xxxxxxxlarge;
  static const double space44 = xxxxxxxxlarge;
  static const double space48 = xxxxxxxxxlarge;

  // Card padding
  static const double cardPadding = cardPaddingMd;
  static const double cardPaddingSmall = cardPaddingSm;

  // Button padding
  static const double buttonPaddingVertical = buttonPaddingVerticalMd;
  static const double buttonPaddingHorizontal = buttonPaddingHorizontalMd;

  // Input padding
  static const double inputPaddingVertical = inputPaddingVerticalMd;
  static const double inputPaddingHorizontal = inputPaddingHorizontalMd;
}

// Icon sizing helpers
class AppIconSize {
  AppIconSize._();

  static const double xs = 16.0;
  static const double s = 20.0;
  static const double m = 24.0;
  static const double l = 28.0;
  static const double xl = 32.0;
}