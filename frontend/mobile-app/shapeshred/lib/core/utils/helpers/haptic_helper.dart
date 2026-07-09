import 'package:flutter/services.dart';

class HapticHelper {
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void success() {
    HapticFeedback.lightImpact();
  }

  static void error() {
    HapticFeedback.heavyImpact();
  }

  static void errorImpact() {
    HapticFeedback.heavyImpact();
  }

  static void successImpact() {
    HapticFeedback.lightImpact();
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }
}
