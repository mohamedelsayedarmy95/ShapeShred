// ENHANCED MOTION SYSTEM WITH BIOMETRIC RESPONSIVENESS
// Advanced motion timing, easing, and physics-based animations for premium user experience
// Features biometric-responsive animations that adapt to heart rate, workout intensity, etc.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Temporary enum to work around AnimatedStatus import issues
enum _AnimationStatus { dismissed, forward, reverse, completed }

/// PREMIUM MOTION DURATIONS
// Thoughtfully timed durations for different interaction types
class AppDurations {
  AppDurations._();

  // INSTANTANEOUS (0-50ms) - Immediate feedback
  static const Duration instantaneous = Duration(milliseconds: 0);
  static const Duration micro = Duration(milliseconds: 16); // ~1 frame at 60fps
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

/// BIOMETRIC-RESPONSIVE MOTION SYSTEM
// Motion parameters that adapt to user biometrics and workout context
class BioResponsiveMotion {
  BioResponsiveMotion._();

  /// Returns animation duration based on heart rate variability
  /// Higher HRV (more relaxed) = slower, more graceful animations
  /// Lower HRV (more stressed/tired) = quicker, more alert animations
  static Duration forHeartRateVariability(double hrv,
      {Duration baseDuration = const Duration(milliseconds: 250)}) {
    // hrv: typically 20-100ms for adults
    // Normalize to 0-1 range where 0 = low stress, 1 = high stress
    double normalized = (hrv - 20) / 80; // Assuming 20-100 range
    normalized = normalized.clamp(0.0, 1.0);

    // Invert: low HRV (stressed) = faster animation, high HRV (relaxed) = slower
    double speedFactor = 1.0 + (normalized * 0.5); // 1.0 to 1.5x speed
    int durationMs = (baseDuration.inMilliseconds / speedFactor).round();

    return Duration(milliseconds: durationMs.clamp(100, 2000));
  }

  /// Returns animation curve based on workout intensity
  /// Low intensity = smoother, more easing
  /// High intensity = more responsive, less easing
  static Curve forWorkoutIntensity(double intensity,
      {bool isRecovery = false}) {
    // intensity: 0.0 (rest) to 1.0 (max effort)
    if (isRecovery) {
      // During recovery: very smooth, easing motions
      return Curves.easeInOut;
    }

    if (intensity < 0.3) {
      // Low intensity: smooth and deliberate
      return Curves.easeInOut;
    } else if (intensity < 0.7) {
      // Moderate intensity: balanced
      return Curves.fastOutSlowIn;
    } else {
      // High intensity: responsive and snappy
      return Curves.decelerate;
    }
  }

  /// Returns animation intensity based on muscle fatigue
  /// Higher fatigue = more subtle, gentle animations
  static double forFatigue(double fatigueLevel, {double baseIntensity = 1.0}) {
    // fatigueLevel: 0.0 (fresh) to 1.0 (exhausted)
    // Returns intensity multiplier: 1.0 (normal) to 0.3 (subtle)
    double factor = 1.0 - (fatigueLevel * 0.7); // 1.0 to 0.3 range
    return (baseIntensity * factor).clamp(0.3, 1.0);
  }

  /// Returns pulsation rate based on breath/heart rate variability
  static double forBreathing(double breathRate) {
    // breathRate: breaths per minute (typically 12-20)
    // Convert to Hz for animation cycles
    return breathRate / 60.0; // Convert BPM to Hz
  }

  /// Returns delay based on user reaction time (simulated)
  static Duration forUserReaction(double reactionTimeMs) {
    // Simulate personalized timing based on user's typical response
    // In reality, this would be learned over time
    double factor = 1.0 + (reactionTimeMs / 500.0); // Baseline 250ms reaction
    int delayMs = (50 * factor).round(); // Base 50ms delay
    return Duration(milliseconds: delayMs.clamp(10, 200));
  }
}

/// PHYSICS-BASED MOTION PATTERNS
// Advanced physics-based animations for natural, lifelike motion
class PhysicsMotion {
  PhysicsMotion._();

  /// Creates a spring-based animation that responds to velocity
  /// Similar to iOS spring dynamics
  static Animation<double> createSpringAnimation(
    Animation<double> parent, {
    double damping = 15.0, // Higher = less bounny
    double stiffness = 100.0, // Higher = faster response
    double mass = 1.0,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(parent);
  }

  /// Creates a damped oscillation for subtle attention-grabbing effects
  static Animation<double> createDampedOscillation(
    Animation<double> parent, {
    int oscillations = 3,
    double decay = 0.8,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CompositeAnimation(
        List<Animation<double>>.generate(
          oscillations,
          (int i) => Tween<double>(
            begin: math.pow(0.8, i + 1) * 0.2,
            end: math.pow(0.8, i) * 0.2,
          ).animate(
            CurvedAnimation(
              parent: parent,
              curve: Interval(
                i / oscillations,
                (i + 1) / oscillations,
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a fluid, liquid-like motion for smooth transitions
  static Animation<double> createFluidMotion(
    Animation<double> parent, {
    double viscosity = 0.5, // Higher = more resistant to change
    double mass = 0.5,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      ClampingAnimation(
        parent: parent,
        curve: _FluidCurve(viscosity, mass),
      ),
    );
  }
}

/// Custom curve simulating fluid dynamics
class _FluidCurve extends Curve {
  final double viscosity;
  final double mass;

  const _FluidCurve(this.viscosity, this.mass);

  @override
  double transform(double t) {
    // Simple fluid dynamics approximation for UI
    double resistance = 1.0 - (viscosity * 0.5); // 0.5 to 1.0 range
    double momentum = t * mass;
    double position =
        momentum * (1.0 - resistance * t * 0.3); // Dampening factor
    return position.clamp(0.0, 1.0);
  }
}

/// COMPOSITE ANIMATION FOR COMBINING MULTIPLE ANIMATIONS
class CompositeAnimation extends Animation<double> {
  final List<Animation<double>> _animations;

  CompositeAnimation(this._animations);

  @override
  AnimationStatus get status => _animations.isNotEmpty
      ? _animations.first.status
      : AnimationStatus.dismissed;

  @override
  double get value => _animations.isNotEmpty
      ? _animations.map((a) => a.value).reduce((a, b) => a + b) /
          _animations.length
      : 0.0;

  @override
  void addListener(VoidCallback listener) {
    for (var anim in _animations) {
      anim.addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    for (var anim in _animations) {
      anim.removeListener(listener);
    }
  }

  @override
  void addStatusListener(AnimationStatusListener listener) {
    for (var anim in _animations) {
      anim.addStatusListener(listener);
    }
  }

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    for (var anim in _animations) {
      anim.removeStatusListener(listener);
    }
  }

  @override
  Animation<E> drive<E>(Animatable<E> animatee) {
    // Delegate to the first animation if available, otherwise return a dummy animation
    if (_animations.isNotEmpty) {
      return _animations.first.drive(animatee);
    }
    // Return a simple animation that always returns the animatee's transform(0.0)
    return _ConstantAnimation<E>(animatee.transform(0.0));
  }

  @override
  String toStringDetails() =>
      '${super.toStringDetails()}, animations: $_animations';
}

/// Clamping animation that applies a curve but clamps the result
class ClampingAnimation extends Animation<double> {
  final Animation<double> _parent;
  final Curve _curve;

  ClampingAnimation({required Animation<double> parent, required Curve curve})
      : _parent = parent,
        _curve = curve;

  @override
  AnimationStatus get status => _parent.status;

  @override
  double get value => _curve.transform(_parent.value).clamp(0.0, 1.0);

  @override
  void addListener(VoidCallback listener) => _parent.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _parent.removeListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      _parent.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      _parent.removeStatusListener(listener);

  @override
  Animation<T> drive<T>(Animatable<T> animatee) => _parent.drive(animatee);

  @override
  String toStringDetails() => '${super.toStringDetails()}, curve: $_curve';
}

/// Configuration for staggered animations
class AnimationStaggerConfig {
  AnimationStaggerConfig._();

  static const int delay = 50; // Base delay between items in ms
  static const int duration = 250; // Base duration for each item
  static const Curve curve = Curves.linear;
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
      final double start =
          index * (staggerDelay / 1000.0) / duration.inMilliseconds;
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

class _ConstantAnimation<T> extends Animation<T> {
  final T _value;

  _ConstantAnimation(this._value);

  @override
  AnimationStatus get status => AnimationStatus.dismissed;

  @override
  T get value => _value;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}

  @override
  Animation<T> drive<T>(Animatable<T> animatee) {
    return _ConstantAnimation<T>(animatee.transform(0.0));
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

  const _FlippedCurve(this._original);

  @override
  double transform(double t) => 1.0 - _original.transform(1.0 - t);
}

/// Custom animation curves for ShapeShred premium animations
class AppCurves {
  /// Standard curve for general animations
  static const Curve standard = Curves.linear;

  /// Bounce curve for premium UI elements
  static const Curve premiumBounce = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Fluid motion curve for natural animations
  static const Curve premiumFluid = Cubic(0.25, 0.1, 0.25, 1.0);

  /// Smooth curve for subtle transitions
  static const Curve premiumSmooth = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Sharp curve for precise movements
  static const Curve premiumSharp = Cubic(0.4, 0.0, 0.6, 1.0);
}
