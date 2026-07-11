// ENHANCED THEME EXTENSION
// Custom theme properties for ShapeShred-specific styling

import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';

@immutable
class ShapeShredThemeExtension
    extends ThemeExtension<ShapeShredThemeExtension> {
  final double workoutCardElevation;
  final double modalElevation;
  final Color cardBackground;
  final Color workoutCardBackground;
  final Color premiumCardBackground;
  final double buttonElevation;
  final double inputFieldElevation;
  final double dividerHeight;
  final double iconSize;
  final double textScaleFactor;

  const ShapeShredThemeExtension({
    required this.workoutCardElevation,
    required this.modalElevation,
    required this.cardBackground,
    required this.workoutCardBackground,
    required this.premiumCardBackground,
    required this.buttonElevation,
    required this.inputFieldElevation,
    required this.dividerHeight,
    required this.iconSize,
    required this.textScaleFactor,
  });

  @override
  ShapeShredThemeExtension copyWith({
    double? workoutCardElevation,
    double? modalElevation,
    Color? cardBackground,
    Color? workoutCardBackground,
    Color? premiumCardBackground,
    double? buttonElevation,
    double? inputFieldElevation,
    double? dividerHeight,
    double? iconSize,
    double? textScaleFactor,
  }) {
    return ShapeShredThemeExtension(
      workoutCardElevation: workoutCardElevation ?? this.workoutCardElevation,
      modalElevation: modalElevation ?? this.modalElevation,
      cardBackground: cardBackground ?? this.cardBackground,
      workoutCardBackground:
          workoutCardBackground ?? this.workoutCardBackground,
      premiumCardBackground:
          premiumCardBackground ?? this.premiumCardBackground,
      buttonElevation: buttonElevation ?? this.buttonElevation,
      inputFieldElevation: inputFieldElevation ?? this.inputFieldElevation,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      iconSize: iconSize ?? this.iconSize,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  @override
  ShapeShredThemeExtension lerp(
      ThemeExtension<ShapeShredThemeExtension>? other, double t) {
    if (other is! ShapeShredThemeExtension) return this;
    return ShapeShredThemeExtension(
      workoutCardElevation:
          _lerpD(workoutCardElevation, other.workoutCardElevation, t),
      modalElevation: _lerpD(modalElevation, other.modalElevation, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      workoutCardBackground:
          Color.lerp(workoutCardBackground, other.workoutCardBackground, t)!,
      premiumCardBackground:
          Color.lerp(premiumCardBackground, other.premiumCardBackground, t)!,
      buttonElevation: _lerpD(buttonElevation, other.buttonElevation, t),
      inputFieldElevation:
          _lerpD(inputFieldElevation, other.inputFieldElevation, t),
      dividerHeight: _lerpD(dividerHeight, other.dividerHeight, t),
      iconSize: _lerpD(iconSize, other.iconSize, t),
      textScaleFactor: _lerpD(textScaleFactor, other.textScaleFactor, t),
    );
  }

  double _lerpD(double a, double b, double t) => a + (b - a) * t;

  // Factory methods for light and dark themes
  factory ShapeShredThemeExtension.light() {
    return ShapeShredThemeExtension(
      workoutCardElevation: 4.0,
      modalElevation: 16.0,
      cardBackground: AppColors.surface,
      workoutCardBackground: AppColors.surfaceVariant,
      premiumCardBackground: AppColors.primary.withOpacity(0.08),
      buttonElevation: 0.0,
      inputFieldElevation: 0.0,
      dividerHeight: 1.0,
      iconSize: 24.0,
      textScaleFactor: 1.0,
    );
  }

  factory ShapeShredThemeExtension.dark() {
    return ShapeShredThemeExtension(
      workoutCardElevation: 4.0,
      modalElevation: 16.0,
      cardBackground: AppColors.surface,
      workoutCardBackground: AppColors.surfaceVariant,
      premiumCardBackground: AppColors.primary.withOpacity(0.08),
      buttonElevation: 0.0,
      inputFieldElevation: 0.0,
      dividerHeight: 1.0,
      iconSize: 24.0,
      textScaleFactor: 1.0,
    );
  }
}
