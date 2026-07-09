// ENHANCED MOTION SYSTEM
// Advanced motion timing and easing for premium user experience

import 'dart:math';
import 'package:flutter/material.dart';

/// PREMIUM MOTION DURATIONS
// Thoughtfully timed durations for different interaction types
class AppDurations {
  AppDurations._();

  // INSTANTANEOUS (0-50ms) - Immediate feedback
  static const Duration instantaneous = Duration(milliseconds: 0);
  static const Duration micro = Duration(milliseconds: 16);  // ~1 frame at 60fps
  static const Duration ultraQuick = Duration(milliseconds: 25);
  static const Duration swift = Duration(milliseconds: 35);

  // IMMEDIATE (50-100ms) - Button presses, toggles
  static const Duration immediate = Duration(milliseconds: 50);
  static const Duration press = Duration(milliseconds: 60);
  static const Duration tap = Duration(milliseconds: 75);

  // QUICK (100-200ms) - Transient UI elements
  static const Duration quick = Duration(milliseconds: 100);
  static const Duration flash = Duration(milliseconds: 120);
  static const Duration blink = Duration(milliseconds: 150);
  static const Duration pulse = Duration(milliseconds: 180);

  // STANDARD (200-300ms) - Primary navigation, card transitions
  static const Duration moderate = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration nav = Duration(milliseconds: 280);

  // SUBSTANTIAL (300-400ms) - Complex transitions, modal dialogs
  static const Duration substantial = Duration(milliseconds: 320);
  static const Duration modal = Duration(milliseconds: 350);
  static const Duration drawer = Duration(milliseconds: 380);

  // EXTENDED (400-600ms) - Major layout changes, immersive transitions
  static const Duration extended = Duration(milliseconds: 420);
  static const Duration immersive = Duration(milliseconds: 480);
  static const Duration cinematic = Duration(milliseconds: 520);
  static const Duration elaborate = Duration(milliseconds: 580);

  // EXTRAVAGANT (600ms+) - Special effects, onboarding
  static const Duration extravagant = Duration(milliseconds: 650);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration leisurely = Duration(milliseconds: 1000);
  static const Duration epic = Duration(milliseconds: 1500);

  // Special purpose durations
  static const Duration splash = Duration(milliseconds: 2000);
  static const Duration onboarding = Duration(milliseconds: 2500);
}

/// PREMIUM MOTION CURVES
// Sophisticated easing functions for natural motion
class AppCurves {
  AppCurves._();

  // === ESSENTIAL CURVES ===
  // The most commonly used curves

  // Standard - for most UI motions
  static const Curve standard = Curves.fastOutSlowIn;
  static const Curve linear = Curves.linear;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // Sharp - for quick, responsive interactions
  static const Curve sharp = Cubic(0.4, 0.0, 0.6, 1);
  static const Curve quick = Cubic(0.33, 0.0, 0.67, 1);
  static const Curve snappy = Cubic(0.3, 0.0, 0.7, 1);

  // Liquid - for fluid, natural motions
  static const Curve fluid = Cubic(0.25, 0.1, 0.25, 1.0);
  static const Curve viscous = Cubic(0.22, 1, 0.36, 1);
  static const Curve elastic = Cubic(0.25, 0.1, 0.25, 1.0);

  // Bouncy - for playful, energetic interactions
  static const Curve bouncy = Cubic(0.68, -0.55, 0.265, 1.55);
  static const Curve springy = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve playful = Cubic(0.42, 0, 0.58, 1);

  // Material Design 3 inspired
  static const Curve m3Standard = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve m3Decelerate = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve m3Accelerate = Cubic(0.4, 0.0, 1.0, 1.0);
  static const Curve m3FastLinearToSlowEaseIn = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve m3FastLinearToSlowEaseOut = Cubic(0.4, 0.0, 0.6, 1.0);

  // Physics-based springs
  static const Curve gentleSpring = Cubic(0.36, 0.0, 0.66, -0.56);
  static const Curve tenseSpring = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve looseSpring = Cubic(0.34, 1.56, 0.64, 1.0);

  // Custom premium curves
  static const Curve premiumSmooth = Cubic(0.25, 0.1, 0.25, 1.0);
  static const Curve premiumSharp = Cubic(0.33, 0.0, 0.67, 1.0);
  static const Curve premiumFluid = Cubic(0.16, 0.84, 0.44, 1.0);
  static const Curve premiumBounce = Cubic(0.68, -0.55, 0.265, 1.55);

  // Specialized curves
  static const Curve frictionless = Cubic(0.0, 0.0, 0.15, 1.0);
  static const Curve withOvershoot = Cubic(0.36, 0.0, 0.66, -0.56);
  static const Curve withAnticipation = Cubic(0.36, 0.0, 0.66, 1.55);
}

// ===== MOTION PATTERNS & PRESETS =====

/// Common animation patterns for consistent usage
class AppMotionPatterns {
  AppMotionPatterns._();

  // FADE PATTERNS
  static const Duration fadeInDuration = AppDurations.moderate;
  static const Curve fadeInCurve = AppCurves.standard;
  static const Duration fadeOutDuration = AppDurations.quick;
  static const Curve fadeOutCurve = AppCurves.standard;

  // SCALE PATTERNS
  static const Duration scaleInDuration = AppDurations.moderate;
  static const Curve scaleInCurve = AppCurves.standard;
  static const Duration scaleOutDuration = AppDurations.quick;
  static const Curve scaleOutCurve = AppCurves.standard;

  // SLIDE PATTERNS
  static const Duration slideInDuration = AppDurations.standard;
  static const Curve slideInCurve = AppCurves.standard;
  static const Duration slideOutDuration = AppDurations.quick;
  static const Curve slideOutCurve = AppCurves.standard;

  // PULSE PATTERNS
  static const Duration pulseDuration = AppDurations.extended;
  static const Curve pulseCurve = AppCurves.elastic;

  // BOUNCE PATTERNS
  static const Duration bounceDuration = AppDurations.extravagant;
  static const Curve bounceCurve = AppCurves.bouncy;

  // FLIP PATTERNS
  static const Duration flipDuration = AppDurations.substantial;
  static const Curve flipCurve = AppCurves.standard;

  // ROTATE PATTERNS
  static const Duration rotateDuration = AppDurations.standard;
  static const Curve rotateCurve = AppCurves.standard;

  // STAGGERED PATTERNS (for lists/grids)
  static const int staggerDelay = 50; // ms between items
  static const Duration staggerDuration = AppDurations.standard;
  static const Curve staggerCurve = AppCurves.standard;
}

/// Helper functions for creating common animations
class AnimationFactory {
  AnimationFactory._();

  static Animation<double> createFadeIn(
    Animation<double> parent, {
    Duration duration = AppDurations.moderate,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<double> createFadeOut(
    Animation<double> parent, {
    Duration duration = AppDurations.quick,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<double> createScaleIn(
    Animation<double> parent, {
    double begin = 0.0,
    double end = 1.0,
    Duration duration = AppDurations.moderate,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<double> createScaleOut(
    Animation<double> parent, {
    double begin = 1.0,
    double end = 0.0,
    Duration duration = AppDurations.quick,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<Offset> createSlideIn(
    Animation<double> parent, {
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = AppDurations.standard,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<Offset> createSlideOut(
    Animation<double> parent, {
    Offset begin = Offset.zero,
    Offset end = const Offset(1.0, 0.0),
    Duration duration = AppDurations.quick,
    Curve curve = AppCurves.standard,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<double> createPulse(
    Animation<double> parent, {
    double minScale = 0.95,
    double maxScale = 1.05,
    Duration duration = AppDurations.extended,
    Curve curve = AppCurves.elastic,
  }) {
    return Tween<double>(begin: minScale, end: maxScale).animate(
      CurvedAnimation(
        parent: parent,
        curve: curve,
        reverseCurve: curve.flipped,
      ),
    );
  }

  static Animation<double> createStaggeredDelay(
    int index, {
    int baseDelay = 0,
    int staggerAmount = AnimationStaggerConfig.delay,
  }) {
    return Tween<double>(begin: 0.0, end: 0.0)
        .animate(Interval(0.0, 1.0));
  }
}

/// Configuration for staggered animations
class AnimationStaggerConfig {
  AnimationStaggerConfig._();

  static const int delay = 50; // Base delay between items in ms
  static const int duration = 250; // Base duration for each item
  static const Curve curve = AppCurves.standard;
}

/// Interval timer for choreographed animations
class IntervalTimer {
  IntervalTimer._();

  static List<Animation<double>> createIntervalSequence(
    Animation<double> parent, {
    int count = 5,
    Duration duration = AppDurations.standard,
    Curve curve = AppCurves.standard,
    int staggerDelay = AnimationStaggerConfig.delay,
  }) {
    return List.generate(count, (index) {
      final double start = index * (staggerDelay / 1000.0) / duration.inMilliseconds;
      final double end = math.min(1.0, start + 1.0);

      return Tween<double>(begin: start, end: end).animate(
        CurvedAnimation(
          parent: parent,
          curve: curve,
        ),
      );
    });
  }
}

// Extension for easy curve inversion
extension CurveFlipped on Curve {
  Curve get flipped {
    // Creates a curve that runs backwards
    return _FlippedCurve(this);
  }
}

class _FlippedCurve extends Curve {
  final Curve _original;

  _FlippedCurve(this._original);

  @override
  double transform(double t) => 1.0 - _original.transform(1.0 - t);
}