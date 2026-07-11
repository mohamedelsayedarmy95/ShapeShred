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
          'recentWorkouts': [],
        };
      }

      final workouts = snapshot.docs.map((doc) => doc.data()).toList();

      int totalDuration = 0;
      int totalCalories = 0;
      List<Map<String, dynamic>> recentWorkouts = [];

      for (var workout in workouts.take(5)) {
        // Get last 5 workouts for recent activity
        recentWorkouts.add({
          'name': workout['name'] ?? 'Workout',
          'date': workout['completedAt'] != null
              ? (workout['completedAt'] as Timestamp).toDate()
              : DateTime.now(),
          'calories': workout['caloriesBurned'] ?? 0,
          'duration': workout['duration'] ?? 0,
        });

        final int duration = ((workout['duration'] ?? 0) as num).toInt();
        final int calories = ((workout['caloriesBurned'] ?? 0) as num).toInt();
        totalDuration += duration;
        totalCalories += calories;
      }

      return {
        'totalWorkouts': workouts.length,
        'totalDuration': totalDuration,
        'totalCalories': totalCalories,
        'recentWorkouts': recentWorkouts,
        'allWorkouts': workouts,
      };
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
