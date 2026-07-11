import 'dart:math' as math;
import 'package:flutter/services.dart';

/// Ultra Premium Haptic Feedback System
/// Provides context-aware haptic feedback that responds to workout intensity,
/// exercise complexity, and user performance metrics
class HapticHelper {
  /// Basic haptic feedback methods (preserved for backward compatibility)
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
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

  /// WORKOUT-SPECIFIC HAPTIC FEEDBACK
  /// Provides context-aware haptic feedback based on workout parameters

  /// Provides haptic feedback for workout completion milestones
  static void workoutMilestone(int milestone) {
    // Different intensity based on milestone significance
    double intensity = math.min(milestone / 10.0, 1.0); // Normalize to 0-1
    int duration = (50 + (intensity * 150)).toInt(); // 50-200ms

    // Create custom haptic pattern based on milestone
    for (int i = 0; i < math.min(milestone, 3); i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  /// Provides haptic feedback for rep completion with form quality
  static void repCompleted({bool goodForm = true, int repCount = 1}) {
    if (goodForm) {
      // Positive reinforcement for good form
      HapticFeedback.lightImpact();
      if (repCount % 5 == 0) {
        // Celebrate every 5th rep with good form
        Future.delayed(const Duration(milliseconds: 100), () {
          HapticFeedback.mediumImpact();
        });
      }
    } else {
      // Gentle correction for poor form
      HapticFeedback.lightImpact();
      Future.delayed(const Duration(milliseconds: 150), () {
        HapticFeedback.lightImpact();
      });
    }
  }

  /// Provides haptic feedback for set completion
  static void setCompleted(int setNumber, int totalSets) {
    double progress = setNumber / totalSets;
    // Intensity based on workout progress
    if (progress >= 0.9) {
      // Final set celebration
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(milliseconds: i * 150), () {
          HapticFeedback.heavyImpact();
        });
      }
    } else if (progress >= 0.7) {
      // Late workout boost
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 100), () {
        HapticFeedback.mediumImpact();
      });
    } else {
      // Regular set completion
      HapticFeedback.mediumImpact();
    }
  }

  /// Provides haptic feedback for rest periods
  static void restStarted(int durationSeconds) {
    // Gentle pulse to signal rest start
    HapticFeedback.lightImpact();
  }

  static void restEnded(int durationSeconds) {
    // More intense pulse to signal rest end
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Provides haptic feedback based on exercise difficulty
  static void exerciseStarted(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        HapticFeedback.lightImpact();
        break;
      case 'intermediate':
        HapticFeedback.mediumImpact();
        break;
      case 'advanced':
        HapticFeedback.heavyImpact();
        break;
      default:
        HapticFeedback.lightImpact();
    }
  }

  /// Provides haptic feedback for heart rate zones
  static void heartRateZoneEntered(String zone) {
    switch (zone.toLowerCase()) {
      case 'warmup':
      case 'zone 1':
        HapticFeedback.lightImpact();
        break;
      case 'fatburn':
      case 'zone 2':
        HapticFeedback.mediumImpact();
        break;
      case 'cardio':
      case 'zone 3':
        // Two quick pulses
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 150), () {
          HapticFeedback.mediumImpact();
        });
        break;
      case 'peak':
      case 'zone 4':
      case 'zone 5':
        // Intense pattern for high intensity
        for (int i = 0; i < 3; i++) {
          Future.delayed(Duration(milliseconds: i * 100), () {
            HapticFeedback.heavyImpact();
          });
        }
        break;
      default:
        HapticFeedback.lightImpact();
    }
  }

  /// Provides haptic feedback for performance milestones
  static void performanceMilestone(String type, double value) {
    // type could be: calories, distance, time, etc.
    // Intensity based on achievement level
    double intensity = 0.5; // Default medium

    if (type == 'calories') {
      intensity =
          (value / 500).clamp(0.0, 1.0); // Assume 500 cal is max for session
    } else if (type == 'distance') {
      intensity =
          (value / 10).clamp(0.0, 1.0); // Assume 10km is max for session
    } else if (type == 'time') {
      intensity =
          (value / 3600).clamp(0.0, 1.0); // Assume 1 hour is max for session
    }

    // Apply haptic feedback based on intensity
    if (intensity > 0.8) {
      // High achievement
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(milliseconds: i * 120), () {
          HapticFeedback.heavyImpact();
        });
      }
    } else if (intensity > 0.5) {
      // Medium achievement
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 150), () {
        HapticFeedback.mediumImpact();
      });
    } else {
      // Low achievement
      HapticFeedback.lightImpact();
    }
  }

  /// Creates a custom haptic pattern for workout transitions
  static void workoutTransition(String fromType, String toType) {
    // Different haptic patterns for different workout type transitions
    if ((fromType == 'rest' && toType == 'exercise') ||
        (fromType == 'exercise' && toType == 'rest')) {
      // Transition between rest and exercise
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.mediumImpact();
      });
    } else if (fromType == 'warmup' && toType == 'workout') {
      // Warmup to main workout
      for (int i = 0; i < 2; i++) {
        Future.delayed(Duration(milliseconds: i * 150), () {
          HapticFeedback.mediumImpact();
        });
      }
    } else if (fromType == 'workout' && toType == 'cooldown') {
      // Workout to cooldown
      HapticFeedback.lightImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.lightImpact();
      });
    } else {
      // Default transition
      HapticFeedback.lightImpact();
    }
  }

  /// Provides adaptive haptic feedback based on user fatigue level
  static void feedbackForFatigue(double fatigueLevel) {
    // fatigueLevel: 0.0 (fresh) to 1.0 (exhausted)
    if (fatigueLevel > 0.8) {
      // High fatigue - gentle, supportive feedback
      HapticFeedback.lightImpact();
    } else if (fatigueLevel > 0.5) {
      // Moderate fatigue - neutral feedback
      HapticFeedback.lightImpact();
    } else {
      // Low fatigue - energizing feedback
      HapticFeedback.mediumImpact();
    }
  }

  /// Provides haptic feedback for form correction during exercise
  static void formFeedback(String feedbackType, double severity) {
    // feedbackType could be: 'depth', 'speed', 'alignment', 'balance'
    // severity: 0.0 (minor) to 1.0 (severe)

    int pulseCount = (severity * 3).ceil(); // 1-3 pulses based on severity
    int delay = (severity * 100).toInt(); // 0-100ms delay based on severity

    for (int i = 0; i < pulseCount; i++) {
      Future.delayed(Duration(milliseconds: delay + (i * 150)), () {
        if (severity > 0.7) {
          HapticFeedback.heavyImpact();
        } else if (severity > 0.3) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      });
    }
  }

  /// Provides celebratory haptic feedback for achievement milestones
  static void achievementUnlocked(String achievementType) {
    // Different celebration patterns for different achievement types
    switch (achievementType.toLowerCase()) {
      case 'consistency':
        // 7-day streak - warm, consistent pattern
        for (int i = 0; i < 5; i++) {
          Future.delayed(Duration(milliseconds: i * 200), () {
            HapticFeedback.mediumImpact();
          });
        }
        break;
      case 'performance':
        // Personal best - exciting, building pattern
        for (int i = 0; i < 3; i++) {
          Future.delayed(Duration(milliseconds: i * 100), () {
            HapticFeedback.heavyImpact();
          });
        }
        break;
      case 'milestone':
        // Round number milestone - celebratory pattern
        for (int i = 0; i < 4; i++) {
          Future.delayed(Duration(milliseconds: i * 150), () {
            if (i % 2 == 0) {
              HapticFeedback.mediumImpact();
            } else {
              HapticFeedback.heavyImpact();
            }
          });
        }
        break;
      default:
        // Generic achievement
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 200), () {
          HapticFeedback.mediumImpact();
        });
    }
  }
}
