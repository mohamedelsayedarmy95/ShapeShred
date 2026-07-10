import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shapeshred/core/services/secure_storage_service.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';

/// Advanced Analytics Service
/// Provides AI-powered insights, predictions, and recommendations for workouts
/// Uses machine learning-inspired algorithms to analyze performance trends
class AdvancedAnalyticsService {
  AdvancedAnalyticsService._();

  static const String _workoutHistoryKey = 'workout_analytics_data';
  static const String _userFitnessProfileKey = 'user_fitness_profile';

  /// Analyze workout performance trends
  /// Returns insights about progress, plateaus, and areas for improvement
  static Future<Map<String, dynamic>> analyzePerformanceTrends(
      List<Map<String, dynamic>> workoutHistory) async {
    if (workoutHistory.isEmpty) {
      return {
        'trend': 'insufficient_data',
        'message': 'Need more workout data to analyze trends',
        'confidence': 0.0,
      };
    }

    // Calculate key metrics over time
    final List<double> volumes = [];
    final List<double> intensities = [];
    final List<double> frequencies = [];

    // Sort workouts by date (oldest first) - FIXED: Properly handle Timestamp objects
    final sortedWorkouts = List<Map<String, dynamic>>.from(workoutHistory)
      ..sort((a, b) {
          final dateA = (a['completedAt'] as Timestamp?)?.toDate();
          final dateB = (b['completedAt'] as Timestamp?)?.toDate();
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return -1; // null dates go first
          if (dateB == null) return 1;  // null dates go first
          return dateA.difference(dateB).inSeconds;
        });

    for (final workout in sortedWorkouts) {
      // Volume = weight * reps * sets (summed across all exercises)
      double volume = 0.0;
      for (final exercise in workout['exercises'] as List<dynamic>) {
        final weight = (exercise['weight'] as num?)?.toDouble() ?? 0.0;
        final reps = (exercise['reps'] as num?)?.toDouble() ?? 0.0;
        final sets = (exercise['set'] as num?)?.toDouble() ?? 0.0;
        volume += weight * reps * sets;
      }
      volumes.add(volume);

      // Average intensity (RPE) across exercises
      final List<double> rpeValues = [];
      for (final exercise in workout['exercises'] as List<dynamic>) {
        final rpe = (exercise['rpe'] as num?)?.toDouble();
        if (rpe != null) rpeValues.add(rpe);
      }
      final double avgRpe =
          rpeValues.isNotEmpty ? rpeValues.reduce((a, b) => a + b) / rpeValues.length : 5.0;
      intensities.add(avgRpe / 10.0); // Normalize to 0-1 scale

      // Frequency (workouts per time period - simplified)
      frequencies.add(1.0);
    }

    // Calculate trends using simple linear regression
    final double volumeTrend = _calculateTrend(volumes);
    final double intensityTrend = _calculateTrend(intensities);
    final double frequencyTrend = _calculateTrend(frequencies);

    // Determine overall progress
    String progressLabel;
    String recommendation;
    double confidence = 0.7;

    if (volumeTrend > 0.1 && intensityTrend > 0.05) {
      progressLabel = 'strong_improvement';
      recommendation =
          'Keep pushing! Your strength and intensity are both increasing.';
    } else if (volumeTrend > 0.05) {
      progressLabel = 'moderate_improvement';
      recommendation =
          'Good progress! Consider increasing intensity to continue gaining strength.';
    } else if (volumeTrend > -0.05 && intensityTrend > -0.05) {
      progressLabel = 'maintenance';
      recommendation =
          'You are maintaining your fitness level. Try varying your routine for growth.';
    } else if (volumeTrend < -0.1) {
      progressLabel = 'potential_overtraining';
      recommendation =
          'Volume is decreasing significantly. Consider rest or reduced intensity.';
    } else {
      progressLabel = 'needs_attention';
      recommendation =
          'Performance may be plateauing. Try changing your routine.';
    }

    // Check for plateaus
    final bool isPlateau = volumeTrend.abs() < 0.02 &&
        intensityTrend.abs() < 0.02 &&
        sortedWorkouts.length >= 4;

    if (isPlateau) {
      progressLabel = 'plateau_detected';
      recommendation =
          'You\'ve hit a plateau! Try varying volume and intensity.';
      confidence = 0.85;
    }

    return {
      'trend': progressLabel,
      'volumeChange': volumeTrend,
      'intensityChange': intensityTrend,
      'frequencyChange': frequencyTrend,
      'recommendation': recommendation,
      'confidence': confidence,
      'isPlateau': isPlateau,
    };
  }

  /// Calculate simple linear trend (slope) for a list of values
  static double _calculateTrend(List<double> values) {
    if (values.length < 2) return 0.0;

    final int n = values.length;
    final List<int> indices = List<int>.generate(n, (i) => i);
    final double sumX = indices.map((i) => i.toDouble()).reduce((a, b) => a + b);
    final double sumY = values.reduce((a, b) => a + b);
    final double sumXY =
        indices.map((i) => i * values[i]).reduce((a, b) => a + b);
    final double sumX2 =
        indices.map((i) => i * i.toDouble()).reduce((a, b) => a + b);

    final double numerator = n * sumXY - sumX * sumY;
    final double denominator = n * sumX2 - sumX * sumX;

    return denominator != 0 ? numerator / denominator : 0.0;
  }

  /// Predict next workout performance based on historical data
  static Future<Map<String, dynamic>> predictNextWorkout(
      List<Map<String, dynamic>> workoutHistory) async {
    if (workoutHistory.length < 3) {
      return {
        'prediction': 'insufficient_data',
        'confidence': 0.0,
        'suggestedVolume': null,
        'suggestedIntensity': null,
      };
    }

    // Sort workouts by date (oldest first) - FIXED: Properly handle Timestamp objects
    final sortedWorkouts = List<Map<String, dynamic>>.from(workoutHistory)
      ..sort((a, b) {
          final dateA = (a['completedAt'] as Timestamp?)?.toDate();
          final dateB = (b['completedAt'] as Timestamp?)?.toDate();
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return -1; // null dates go first
          if (dateB == null) return 1;  // null dates go first
          return dateA.difference(dateB).inSeconds;
        });

    // Get recent workouts (last 5)
    final List<Map<String, dynamic>> recentWorkouts =
        sortedWorkouts.length > 5
            ? sortedWorkouts.sublist(sortedWorkouts.length - 5)
            : sortedWorkouts;

    // Calculate average volume and intensity from recent workouts
    final List<double> recentVolumes = [];
    final List<double> recentIntensities = [];

    for (final workout in recentWorkouts) {
      double volume = 0.0;
      for (final exercise in workout['exercises']) {
        final weight = (exercise['weight'] as double?) ?? 0.0;
        final reps = (exercise['reps'] as int)?.toDouble() ?? 0.0;
        final sets = (exercise['set'] as int)?.toDouble() ?? 0.0;
        volume += weight * reps * sets;
      }
      recentVolumes.add(volume);

      final List<int> rpeValues = [];
      for (final exercise in workout['exercises']) {
        final rpe = exercise['rpe'] as int?;
        if (rpe != null) rpeValues.add(rpe);
      }
      final double avgRpe =
          rpeValues.isNotEmpty ? rpeValues.reduce((a, b) => a + b) / rpeValues.length : 5.0;
      recentIntensities.add(avgRpe / 10.0);
    }

    // Predict next workout based on trend
    final double avgVolume =
        recentVolumes.reduce((a, b) => a + b) / recentVolumes.length;
    final double avgIntensity =
        recentIntensities.reduce((a, b) => a + b) / recentIntensities.length;

    final double volumeTrend = _calculateTrend(recentVolumes);
    final double intensityTrend = _calculateTrend(recentIntensities);

    // Apply trend with some randomness to simulate biological variability
    final double predictedVolume =
        (avgVolume + volumeTrend) * (0.8 + Random().nextDouble() * 0.4);
    final double predictedIntensity =
        (avgIntensity + intensityTrend) * (0.8 + Random().nextDouble() * 0.4);

    // Ensure values are within reasonable bounds
    final double clampedVolume = predictedVolume.clamp(0, avgVolume * 2);
    final double clampedIntensity = predictedIntensity.clamp(0.3, 0.95);

    // Determine confidence based on data consistency
    final double volumeStdDev = _calculateStandardDeviation(recentVolumes);
    final double intensityStdDev =
        _calculateStandardDeviation(recentIntensities);
    final double consistency =
        1.0 - ((volumeStdDev / (avgVolume + 0.1)) + (intensityStdDev / (avgIntensity + 0.1))) / 2;
    final double confidence = (0.5 + consistency * 0.5).clamp(0.3, 0.9);

    String predictionLabel;
    if (volumeTrend > 0.1 && intensityTrend > 0.05) {
      predictionLabel = 'progressive_overload';
    } else if (volumeTrend < -0.1) {
      predictionLabel = 'deload_recommended';
    } else if (intensityTrend > 0.1) {
      predictionLabel = 'intensity_focus';
    } else {
      predictionLabel = 'maintenance';
    }

    return {
      'prediction': predictionLabel,
      'confidence': confidence,
      'suggestedVolume': clampedVolume.round(),
      'suggestedIntensity': (clampedIntensity * 10).roundToDouble(), // Convert back to RPE scale
      'volumeTrend': volumeTrend,
      'intensityTrend': intensityTrend,
      'recentAverageVolume': avgVolume.round(),
      'recentAverageIntensity': (avgIntensity * 10).roundToDouble(),
    };
  }

  /// Calculate standard deviation
  static double _calculateStandardDeviation(List<double> values) {
    if (values.isEmpty) return 0.0;
    if (values.length == 1) return 0.0;

    final double mean =
        values.reduce((a, b) => a + b) / values.length;
    final double variance = values
        .map((v) => (v - mean) * (v - mean))
        .reduce((a, b) => a + b) /
        values.length;
    return sqrt(variance);
  }

  /// Generate personalized workout recommendations
  static Future<List<Map<String, dynamic>>> generateRecommendations(
      List<Map<String, dynamic>> workoutHistory,
      String primaryGoal,
      String fitnessLevel,
  ) async {
    final List<Map<String, dynamic>> recommendations = [];

    // Analyze recent workout patterns
    final Map<String, dynamic> trendAnalysis =
        await analyzePerformanceTrends(workoutHistory);

    // Base recommendations on goals
    switch (primaryGoal.toLowerCase()) {
      case 'lose_weight':
        recommendations.addAll(_getFatLossRecommendations(
            trendAnalysis, fitnessLevel, workoutHistory));
        break;
      case 'build_muscle':
        recommendations.addAll(_getMuscleBuildingRecommendations(
            trendAnalysis, fitnessLevel, workoutHistory));
        break;
      case 'endurance':
        recommendations.addAll(_getEnduranceRecommendations(
            trendAnalysis, fitnessLevel, workoutHistory));
        break;
      default:
        recommendations.addAll(_getGeneralFitnessRecommendations(
            trendAnalysis, fitnessLevel, workoutHistory));
    }

    // Add injury prevention recommendations if needed
    if (trendAnalysis['isPlateau'] == true ||
        trendAnalysis['trend'] == 'potential_overtraining') {
      recommendations.add({
        'type': 'recovery',
        'title': 'Active Recovery Week',
        'description':
            'Your data suggests you might benefit from a deload week to prevent overtraining and promote recovery.',
        'icon': Icons.self_improvement,
        'priority': 'high',
        'duration': '1 week',
        'action': 'Reduce volume by 40-50% and focus on mobility work',
      });
    }

    return recommendations;
  }

  static List<Map<String, dynamic>> _getFatLossRecommendations(
      Map<String, dynamic> trendAnalysis,
      String fitnessLevel,
      List<Map<String, dynamic>> workoutHistory,
  ) {
    final List<Map<String, dynamic>> recs = [];

    // HIIT recommendation for fat loss
    recs.add({
      'type': 'hiit',
      'title': 'High-Intensity Interval Training',
      'description':
          'Incorporate 2-3 HIIT sessions per week to maximize fat burning and metabolic rate.',
      'icon': Icons.flash_on,
      'priority': 'high',
      'duration': '20-30 minutes',
      'action': 'Try sprint intervals, circuit training, or tabata workouts',
    });

    // Fasted cardio suggestion
    if (int.parse(fitnessLevel) >= 2) {
      // Intermediate or advanced
      recs.add({
        'type': 'fasted_cardio',
        'title': 'Fasted Cardio',
        'description':
            'Low-intensity cardio in a fasted state can enhance fat utilization.',
        'icon': Icons.wb_sunny,
        'priority': 'medium',
        'duration': '30-45 minutes',
        'action': 'Try brisk walking or light cycling before breakfast',
      });
    }

    // Adjust based on progress
    if (trendAnalysis['trend'] == 'plateau_detected') {
      recs.add({
        'type': 'variety',
        'title': 'Workout Variety',
        'description':
            'Your body has adapted to your current routine. Introduce new exercises and training modalities.',
        'icon': Icons.refresh,
        'priority': 'high',
        'duration': 'Ongoing',
        'action': 'Try new cardio formats, change exercise order, or try different equipment',
      });
    }

    return recs;
  }

  static List<Map<String, dynamic>> _getMuscleBuildingRecommendations(
      Map<String, dynamic> trendAnalysis,
      String fitnessLevel,
      List<Map<String, dynamic>> workoutHistory,
  ) {
    final List<Map<String, dynamic>> recs = [];

    // Progressive overload reminder
    recs.add({
      'type': 'progressive_overload',
      'title': 'Progressive Overload',
      'description':
          'Gradually increase weight, reps, or sets over time to stimulate muscle growth.',
      'icon': Icons.trending_up,
      'priority': 'high',
      'duration': 'Every workout',
      'action': 'Aim to increase weight by 2.5-5% when you can complete all reps with good form',
    });

    // Protein timing
    recs.add({
      'type': 'nutrition',
      'title': 'Protein Timing',
      'description':
          'Consume protein within 30-60 minutes after workouts to maximize muscle protein synthesis.',
      'icon': Icons.restaurant,
      'priority': 'medium',
      'duration': 'Post-workout',
      'action': 'Aim for 20-40g of high-quality protein after training',
    });

    // Compound movements focus
    if (trendAnalysis['isPlateau'] == true) {
      recs.add({
        'type': 'compound_focus',
        'title': 'Compound Movement Emphasis',
        'description':
            'Focus on compound lifts like squats, deadlifts, bench press, and overhead press for maximum muscle stimulation.',
        'icon': Icons.fitness_center,
        'priority': 'high',
        'duration': '4-6 weeks',
        'action': 'Build your workouts around 3-4 compound movements per session',
      });
    }

    return recs;
  }

  static List<Map<String, dynamic>> _getEnduranceRecommendations(
      Map<String, dynamic> trendAnalysis,
      String fitnessLevel,
      List<Map<String, dynamic>> workoutHistory,
  ) {
    final List<Map<String, dynamic>> recs = [];

    // Aerobic base building
    recs.add({
      'type': 'aerobic_base',
      'title': 'Aerobic Base Building',
      'description':
          'Spend 80% of your training time at low intensity to build aerobic endurance.',
      'icon': Icons.terrain,
      'priority': 'high',
      'duration': 'Ongoing',
      'action': 'Keep heart rate in zone 2 (60-70% max HR) for most of your workout',
    });

    // Interval training
    if (int.parse(fitnessLevel) >= 2) {
      // Intermediate or advanced
      recs.add({
        'type': 'interval_training',
        'title': 'Interval Training',
        'description':
            'Include 1-2 high-intensity interval sessions per week to improve VO2 max.',
        'icon': Icons.fitness_center,
        'priority': 'medium',
        'duration': '20-30 minutes',
        'action': 'Try 4x4 minute intervals at 85-95% max HR with 3-minute recoveries',
      });
    }

    // Long slow distance
    if (trendAnalysis['workoutCount'] > 4) {
      // Enough data to make recommendation
      recs.add({
        'type': 'long_distance',
        'title': 'Weekly Long Session',
        'description':
            'Include one longer session per week to build endurance and mental toughness.',
        'icon': Icons.straighten,
        'priority': 'medium',
        'duration': '60-90 minutes',
        'action': 'Go for a long run, bike ride, or swim at conversational pace',
      });
    }

    return recs;
  }

  static List<Map<String, dynamic>> _getGeneralFitnessRecommendations(
      Map<String, dynamic> trendAnalysis,
      String fitnessLevel,
      List<Map<String, dynamic>> workoutHistory,
  ) {
    final List<Map<String, dynamic>> recs = [];

    // Balanced routine reminder
    recs.add({
      'type': 'balance',
      'title': 'Balanced Training',
      'description':
          'Include strength, cardio, flexibility, and mobility work in your weekly routine.',
      'icon': Icons.balance,
      'priority': 'medium',
      'duration': 'Weekly',
      'action': 'Aim for 2-3 strength sessions, 2 cardio sessions, and daily mobility work',
    });

    // Recovery importance
    recs.add({
      'type': 'recovery',
      'title': 'Recovery Focus',
      'description':
          'Adequate sleep, hydration, and nutrition are crucial for progress and injury prevention.',
      'icon': Icons.nightlight_round,
      'priority': 'high',
      'duration': 'Daily',
      'action': 'Aim for 7-9 hours of sleep, drink plenty of water, and eat nutrient-dense foods',
    });

    // Form and technique
    if (workoutHistory.length > 2) {
      recs.add({
        'type': 'form_focus',
        'title': 'Form & Technique',
        'description':
            'Regularly check your form to prevent injuries and ensure effective muscle targeting.',
        'icon': Icons.slow_motion_video,
        'priority': 'medium',
        'duration': 'Every workout',
        'action': 'Record yourself performing key exercises or work with a trainer periodically',
      });
    }

    return recs;
  }

  /// Detect potential overtraining or injury risk
  static Future<Map<String, dynamic>> assessRecoveryStatus(
      List<Map<String, dynamic>> recentWorkouts,
  ) async {
    if (recentWorkouts.isEmpty) {
      return {
        'riskLevel': 'unknown',
        'factors': [],
        'recommendations': ['Insufficient data to assess recovery status'],
      };
    }

    final List<String> riskFactors = [];
    final List<String> recommendations = [];

    // Calculate average RPE over last 3 workouts
    final List<double> recentRPE = [];
    for (final workout in recentWorkouts.reversed.take(3)) {
      final List<int> rpeValues = [];
      for (final exercise in workout['exercises']) {
        final rpe = exercise['rpe'] as int?;
        if (rpe != null) rpeValues.add(rpe);
      }
      if (rpeValues.isNotEmpty) {
        final double avgRpe =
            rpeValues.reduce((a, b) => a + b) / rpeValues.length;
        recentRPE.add(avgRpe);
      }
    }

    if (recentRPE.isNotEmpty) {
      final double avgRpe =
          recentRPE.reduce((a, b) => a + b) / recentRPE.length;
      if (avgRpe > 8.5) {
        riskFactors.add('Consistently high perceived exertion');
        recommendations.add(
            'Consider reducing workout intensity or adding extra rest days');
      }
    }

    // Check workout frequency
    if (recentWorkouts.length >= 5) {
      // More than 5 workouts in whatever time period the data represents
      riskFactors.add('High training frequency');
      recommendations.add(
          "Ensure you're getting adequate recovery between sessions");
    }

    // Check for monotony (same exercises repeatedly)
    final Set<String> exerciseIds = {};
    for (final workout in recentWorkouts) {
      for (final exercise in workout['exercises']) {
        exerciseIds.add(exercise['exerciseId'] as String);
      }
    }
    if (exerciseIds.length < 3 && recentWorkouts.length >= 3) {
      riskFactors.add('Low exercise variety');
      recommendations.add(
          'Vary your exercise selection to prevent overuse injuries');
    }

    // Determine risk level
    String riskLevel = 'low';
    if (riskFactors.length >= 2) {
      riskLevel = 'moderate';
    }
    if (riskFactors.length >= 3) {
      riskLevel = 'high';
    }

    return {
      'riskLevel': riskLevel,
      'factors': riskFactors,
      'recommendations': recommendations.isEmpty
          ? ['Recovery status appears good based on available data']
          : recommendations,
    };
  }

  /// Calculate fitness age based on performance metrics
  static Future<int> calculateFitnessAge(
      int chronologicalAge, Map<String, dynamic> recentMetrics) async {
    // This is a simplified model - in reality would use more complex algorithms
    // based on VO2 max, strength ratios, flexibility, etc.

    int fitnessAge = chronologicalAge;

    // Adjust based on resting heart rate (if available)
    final int? restingHR = recentMetrics['restingHeartRate'];
    if (restingHR != null) {
      // Lower resting HR = younger fitness age
      if (restingHR < 60) {
        fitnessAge -= 5;
      } else if (restingHR > 80) {
        fitnessAge += 5;
      }
    }

    // Adjust based on VO2 max estimate (if available)
    final double? vo2Max = recentMetrics['vo2Max'];
    if (vo2Max != null) {
      // Higher VO2 max = younger fitness age
      // Average VO2 max for age: roughly 50 - (0.5 * age)
      final double expectedVO2Max = 50.0 - (0.5 * chronologicalAge);
      if (vo2Max > expectedVO2Max + 10) {
        fitnessAge -= 10;
      } else if (vo2Max < expectedVO2Max - 10) {
        fitnessAge += 10;
      }
    }

    // Adjust based on strength-to-weight ratio (if available)
    final double? strengthRatio = recentMetrics['strengthToWeightRatio'];
    if (strengthRatio != null) {
      // Higher ratio = younger fitness age
      // Rough benchmark: 1.0+ for excellent strength-to-weight
      if (strengthRatio > 1.2) {
        fitnessAge -= 7;
      } else if (strengthRatio < 0.8) {
        fitnessAge += 7;
      }
    }

    // Ensure reasonable bounds
    return fitnessAge.clamp(20, 80);
  }
}