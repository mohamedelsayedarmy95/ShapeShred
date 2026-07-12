import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/error/failures.dart';

/// Repository for managing workout history data
abstract class WorkoutHistoryRepository {
  /// Stream of workout history for the current user
  Stream<List<Map<String, dynamic>>> getWorkoutHistory();

  /// Save a completed workout to history
  Future<void> saveWorkout(Map<String, dynamic> workoutData);

  /// Delete a workout from history
  Future<void> deleteWorkout(String workoutId);

  /// Get workout statistics for analytics
  Future<Map<String, dynamic>> getWorkoutStatistics();
}

/// Firebase implementation of the workout history repository
class FirebaseWorkoutHistoryRepository implements WorkoutHistoryRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  FirebaseWorkoutHistoryRepository({
    required FirebaseFirestore firestore,
    required String userId,
  })  : _firestore = firestore,
        _userId = userId;

  @override
  Stream<List<Map<String, dynamic>>> getWorkoutHistory() {
    try {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('workout_history')
          .orderBy('completedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data(),
                  })
              .toList());
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<void> saveWorkout(Map<String, dynamic> workoutData) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workout_history')
          .add(workoutData);
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workout_history')
          .doc(workoutId)
          .delete();
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<Map<String, dynamic>> getWorkoutStatistics() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workout_history')
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'totalWorkouts': 0,
          'totalDuration': 0,
          'totalCalories': 0,
          'activeDays': 0,
          'workoutsThisWeek': 0,
          'workoutsLastWeek': 0,
          'weeklyActivity': List<double>.filled(7, 0.0),
          'recentWorkouts': <Map<String, dynamic>>[],
          'allWorkouts': <Map<String, dynamic>>[],
        };
      }

      final workouts = snapshot.docs.map((doc) => doc.data()).toList();

      int totalDuration = 0;
      int totalCalories = 0;
      int workoutsThisWeek = 0;
      int workoutsLastWeek = 0;
      final Set<String> activeDayKeys = {};
      // Minutes per weekday (Mon..Sun) of the current week.
      final List<double> weekMinutes = List.filled(7, 0.0);

      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime weekStart =
          today.subtract(Duration(days: now.weekday - 1));
      final DateTime lastWeekStart = weekStart.subtract(const Duration(days: 7));

      final List<Map<String, dynamic>> recentWorkouts = [];

      for (final workout in workouts) {
        final DateTime date = workout['completedAt'] != null
            ? (workout['completedAt'] as Timestamp).toDate()
            : DateTime.now();
        // Older records stored seconds under totalDuration; fall back.
        final int duration = ((workout['duration'] ??
                (((workout['totalDuration'] ?? 0) as num) / 60).ceil())
            as num)
            .toInt();
        final int calories =
            ((workout['caloriesBurned'] ?? 0) as num).toInt();

        totalDuration += duration;
        totalCalories += calories;
        activeDayKeys.add('${date.year}-${date.month}-${date.day}');

        if (!date.isBefore(weekStart)) {
          workoutsThisWeek++;
          weekMinutes[date.weekday - 1] += duration;
        } else if (!date.isBefore(lastWeekStart)) {
          workoutsLastWeek++;
        }

        if (recentWorkouts.length < 5) {
          recentWorkouts.add({
            'name': workout['name'] ?? 'Workout',
            'date': date,
            'calories': calories,
            'duration': duration,
          });
        }
      }

      // Normalize the weekly chart to 0..1 against the busiest day.
      final double maxMinutes =
          weekMinutes.reduce((a, b) => a > b ? a : b);
      final List<double> weeklyActivity = maxMinutes > 0
          ? weekMinutes.map((m) => m / maxMinutes).toList()
          : List<double>.filled(7, 0.0);

      return {
        'totalWorkouts': workouts.length,
        'totalDuration': totalDuration,
        'totalCalories': totalCalories,
        'activeDays': activeDayKeys.length,
        'workoutsThisWeek': workoutsThisWeek,
        'workoutsLastWeek': workoutsLastWeek,
        'weeklyActivity': weeklyActivity,
        'recentWorkouts': recentWorkouts,
        'allWorkouts': workouts,
      };
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
