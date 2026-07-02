import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color primary;
  final Color surface;
  final Color error;

  const AppThemeExtension({
    required this.primary,
    required this.surface,
    required this.error,
  });

  @override
  AppThemeExtension copyWith({
    Color? primary,
    Color? surface,
    Color? error,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      surface: surface ?? this.surface,
      error: error ?? this.error,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
