import 'package:flutter/material.dart';
import 'package:shapeshred/core/services/secure_storage_service.dart';

/// Ultra Premium Theme Service
/// Manages theme persistence and switching
class ThemeService {
  ThemeService._();

  static const String _themeKey = 'app_theme_mode';

  static ThemeMode _currentThemeMode = ThemeMode.light;

  /// Initialize theme service
  static Future<void> initialize() async {
    final savedTheme = await SecureStorageService.read(_themeKey);
    if (savedTheme != null) {
      _currentThemeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  /// Get current theme mode
  static ThemeMode get themeMode => _currentThemeMode;

  /// Check if dark mode is active
  static bool get isDarkMode => _currentThemeMode == ThemeMode.dark;

  /// Switch theme
  static Future<void> switchTheme() async {
    _currentThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await SecureStorageService.write(_themeKey, isDarkMode ? 'dark' : 'light');
  }

  /// Set specific theme
  static Future<void> setTheme(ThemeMode mode) async {
    _currentThemeMode = mode;
    await SecureStorageService.write(_themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
