import 'package:flutter/services.dart';

class HapticHelper {
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  static Future<void> success() async {
    // Custom success pattern if needed, or just light impact
    await HapticFeedback.lightImpact();
  }

  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }
}
