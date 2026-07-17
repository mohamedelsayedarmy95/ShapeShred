import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App language, independent of the system locale once the user picks one.
/// `null` means "follow the system".
class LocaleService {
  LocaleService._();

  static const String _localeKey = 'app_locale';

  static final ValueNotifier<Locale?> localeNotifier =
      ValueNotifier<Locale?>(null);

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null && code.isNotEmpty) {
      localeNotifier.value = Locale(code);
    }
  }

  /// Pass `null` to follow the system locale again.
  static Future<void> setLocale(Locale? locale) async {
    localeNotifier.value = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }
}
