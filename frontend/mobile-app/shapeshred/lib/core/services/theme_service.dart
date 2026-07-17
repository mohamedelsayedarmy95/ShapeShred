import 'package:flutter/material.dart';
import 'package:shapeshred/core/services/secure_storage_service.dart';

/// Ultra Premium Theme Service
/// Manages theme persistence and switching
class ThemeService {
  ThemeService._();

  static const String _themeKey = 'app_theme_mode';

  /// Notifies listeners (e.g. the root MaterialApp) whenever the theme
  /// mode changes, so the whole app rebuilds with the new palette.
  static final ValueNotifier<ThemeMode> modeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Initialize theme service
  static Future<void> initialize() async {
    final savedTheme = await SecureStorageService.read(_themeKey);
    if (savedTheme != null) {
      modeNotifier.value =
          savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    }
  }

  /// Get current theme mode
  static ThemeMode get themeMode => modeNotifier.value;

  /// Check if dark mode is active
  static bool get isDarkMode => modeNotifier.value == ThemeMode.dark;

  /// Switch theme
  static Future<void> switchTheme() async {
    await setTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  /// Set specific theme
  static Future<void> setTheme(ThemeMode mode) async {
    modeNotifier.value = mode;
    await SecureStorageService.write(
        _themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
