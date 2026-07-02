import 'package:flutter/material.dart';

@immutable
class ShapeShredThemeExtension
    extends ThemeExtension<ShapeShredThemeExtension> {
  final double workoutCardElevation;
  final double modalElevation;
  final Color cardBackground;

  const ShapeShredThemeExtension({
    required this.workoutCardElevation,
    required this.modalElevation,
    required this.cardBackground,
  });

  @override
  ShapeShredThemeExtension copyWith({
    double? workoutCardElevation,
    double? modalElevation,
    Color? cardBackground,
  }) {
    return ShapeShredThemeExtension(
      workoutCardElevation: workoutCardElevation ?? this.workoutCardElevation,
      modalElevation: modalElevation ?? this.modalElevation,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  ShapeShredThemeExtension lerp(
      ThemeExtension<ShapeShredThemeExtension>? other, double t) {
    if (other is! ShapeShredThemeExtension) return this;
    return ShapeShredThemeExtension(
      workoutCardElevation:
          lerpDouble(workoutCardElevation, other.workoutCardElevation, t) ??
              workoutCardElevation,
      modalElevation:
          lerpDouble(modalElevation, other.modalElevation, t) ?? modalElevation,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
    );
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
