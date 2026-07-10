import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/features/training/data/workout_history_repository.dart';
import 'package:shapeshred/providers/firebase_providers.dart';

// ---------------------------------------------------------------------------
// 1️⃣ Immutable state that the UI will read
// ---------------------------------------------------------------------------
class WorkoutSessionState {
  final bool isLoading;          // true while we’re waiting for the workout config
  final CustomWorkout? workout;  // the whole workout the user selected
  final int exerciseIndex;       // which exercise we’re on (0‑based)
  final int setIndex;            // which set we’re on (1‑based)
  final int repCount;            // reps completed in the current set
  final bool isResting;          // true → we’re showing the rest timer
  final bool isPaused;           // user‑initiated pause (exercise timer)
  final bool isFinished;         // workout is done and we’ve saved it
  final Duration elapsed;        // total elapsed workout time (excluding rest)
  final Map<String, dynamic> workoutLog; // the map we’ll hand to the repository

  const WorkoutSessionState({
    this.isLoading = true,
    this.workout,
    this.exerciseIndex = 0,
    this.setIndex = 1,
    this.repCount = 0,
    this.isResting = false,
    this.isPaused = false,
    this.isFinished = false,
    this.elapsed = Duration.zero,
    this.workoutLog = const {},
  });

  // ----- Helper copyWith for immutable updates -----
  WorkoutSessionState copyWith({
    bool? isLoading,
    CustomWorkout? workout,
    int? exerciseIndex,
    int? setIndex,
    int? repCount,
    bool? isResting,
    bool? isPaused,
    bool? isFinished,
    Duration? elapsed,
    Map<String, dynamic>? workoutLog,
  }) =>
      WorkoutSessionState(
        isLoading: isLoading ?? this.isLoading,
        workout: workout ?? this.workout,
        exerciseIndex: exerciseIndex ?? this.exerciseIndex,
        setIndex: setIndex ?? this.setIndex,
        repCount: repCount ?? this.repCount,
        isResting: isResting ?? this.isResting,
        isPaused: isPaused ?? this.isPaused,
        isFinished: isFinished ?? this.isFinished,
        elapsed: elapsed ?? this.elapsed,
        workoutLog: workoutLog ?? this.workoutLog,
      );

  // Convenience: get the current Exercise object (or null if out of range)
  Exercise? get currentExercise =>
      workout?.exercises.isNotEmpty == true &&
          exerciseIndex < workout!.exercises.length
          ? workout!.exercises[exerciseIndex]
          : null;
}

// ---------------------------------------------------------------------------
// 2️⃣ The notifier – holds mutable state and runs the timer
// ---------------------------------------------------------------------------
class WorkoutSessionNotifier extends StateNotifier<WorkoutSessionState> {
  final Ref _ref;               // needed to read providers (repo, auth, etc.)
  Timer? _tickTimer;            // fires every second for the workout clock
  Timer? _restTimer;            // counts down the rest period
  DateTime? _sessionStart;      // when the workout actually started (excludes paused time)

  // Ctor – we receive a Ref so we can read other providers inside the notifier
  WorkoutSessionNotifier(this._ref, CustomWorkout workout)
      : super(WorkoutSessionState(
          isLoading: false,
          workout: workout,
          exerciseIndex: 0,
          setIndex: 1,
          repCount: 0,
          isResting: false,
          isPaused: false,
          isFinished: false,
          elapsed: Duration.zero,
          workoutLog: {
            'userId': _ref.read(workoutUserIdProvider)!,
            'exercises': <Map<String, dynamic>>[],
            'totalDuration': 0,
            'totalCalories': 0,
            'completedAt': null,
          },
        )) {
    _startWorkoutClock();
  }

  // -----------------------------------------------------------------
  // 3️⃣ Tick‑timer – updates `elapsed` every second while not paused
  // -----------------------------------------------------------------
  void _startWorkoutClock() {
    _stopTimers(); // just in case
    _sessionStart = DateTime.now().subtract(state.elapsed);
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && !state.isFinished) {
        final now = DateTime.now();
        final elapsed = now.difference(_sessionStart!);
        // Count only the *active* exercise time (skip rest periods)
        if (!state.isResting) {
          state = state.copyWith(elapsed: elapsed);
        }
      }
    });
  }

  void _stopTimers() {
    _tickTimer?.cancel();
    _restTimer?.cancel();
    _tickTimer = null;
    _restTimer = null;
  }

  // -----------------------------------------------------------------
  // 4️⃣ Public actions that the UI can call
  // -----------------------------------------------------------------

  /// Call when the user presses **Start** on the first exercise.
  void startExercise() {
    // Nothing special – the timer is already running in the constructor.
    // Just make sure we’re not paused.
    if (state.isPaused) {
      state = state.copyWith(isPaused: false);
    }
  }

  /// Call when the user presses **Pause**.
  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
  }

  /// Call when the user presses **Resume**.
  void resumeWorkout() {
    state = state.copyWith(isPaused: false);
    // Adjust the start time so the elapsed clock doesn’t jump.
    _sessionStart = DateTime.now().subtract(state.elapsed);
  }

  /// Call when the user finishes a set (i.e. hits the “+ rep” button enough times
  /// to reach the target rep count for the current exercise).
  void completeSet() {
    final ex = state.currentExercise;
    if (ex == null) return;

    // Determine if we have reached the target rep count for this set.
    final targetReps = _targetRepsForSet(ex, state.setIndex);
    if (state.repCount >= targetReps) {
      // Move to next set or next exercise.
      if (state.setIndex < ex.setsPerExercise) {
        // Same exercise, next set
        state = state.copyWith(
          setIndex: state.setIndex + 1,
          repCount: 0,
          isResting: true, // start rest timer
        );
        _startRestTimer();
      } else {
        // Last set of this exercise – move to next exercise (if any)
        final nextIdx = state.exerciseIndex + 1;
        if (nextIdx < (state.workout!.exercises.length)) {
          state = state.copyWith(
            exerciseIndex: nextIdx,
            setIndex: 1,
            repCount: 0,
            isResting: false,
          );
        } else {
          // No more exercises – workout finished
          _finishWorkout();
        }
      }
    }
  }

  /// Call when the user taps the **skip** button (skip current exercise entirely).
  void skipExercise() {
    final nextIdx = state.exerciseIndex + 1;
    if (nextIdx < (state.workout!.exercises.length)) {
      state = state.copyWith(
        exerciseIndex: nextIdx,
        setIndex: 1,
        repCount: 0,
        isResting: false,
      );
    } else {
      _finishWorkout();
    }
  }

  /// Call when the user presses the **rest‑timer skip** button (optional).
  void skipRest() {
    _stopRestTimer();
    state = state.copyWith(isResting: false);
  }

  // -----------------------------------------------------------------
  // 5️⃣ Helper: start/restart the rest‑timer (uses a separate Timer)
  // -----------------------------------------------------------------
  void _startRestTimer() {
    // Assume each rest period is defined in the exercise (seconds)
    final restSecs = state.currentExercise?.restBetweenSets ?? 30;
    _stopRestTimer();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (restSecs <= 1) {
        _stopRestTimer();
        // Rest period ended – go back to the exercise timer
        state = state.copyWith(isResting: false);
        // Reset rep count for the new set (if we stayed on same exercise)
        if (state.setIndex > 1) {
          // we just finished a rest, so we are starting a new set
          state = state.copyWith(repCount: 0);
        }
        return;
      }
      // We keep the flag `isResting` and let the UI show a countdown based on
      // the original restSecs and the elapsed time of this timer.
      // A more refined version would store `remainingRest` in the state.
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    _restTimer = null;
  }

  // -----------------------------------------------------------------
  // 6️⃣ Helper: compute target reps for a given set (supports pyramids, etc.)
  // -----------------------------------------------------------------
  int _targetRepsForSet(Exercise ex, int setNumber) {
    // Example: if you store a list `repsPerSet` in Exercise, use it.
    // Fallback to a simple constant if not present.
    // Get the current WorkoutExercise which contains the reps info
    final workoutExercise = state.workout?.exercises[state.exerciseIndex];
    if (workoutExercise != null) {
      // If the list is shorter than the number of sets, repeat the last value.
      final index = (setNumber - 1).clamp(0, repsPerSet.length - 1);
      return repsPerSet[index];
    }
    // Default: use the exercise’s defaultRepCount (you can add this field)
    return ex.defaultRepCount ?? 10;
  }

  // -----------------------------------------------------------------
  // 7️⃣ Finish the workout – persist the log and mark state as finished
  // -----------------------------------------------------------------
  Future<void> _finishWorkout() async {
    _stopTimers();

    // Build the final workout log map (already being updated incrementally)
    final log = Map<String, dynamic>.from(state.workoutLog)
      ..['totalDuration'] = state.elapsed.inSeconds
      ..['completedAt'] = FieldValue.serverTimestamp();

    try {
      final repo = _ref.read(workoutHistoryRepositoryProvider);
      await repo.saveWorkout(log);
    } catch (e) {
      // In a real app you would surface this to the user via a snackbar/toast.
      // For now we just log it – you can extend the state with an
      // `String? errorMessage` if you want to show it.
      debugPrint('Failed to save workout: $e');
    }

    state = state.copyWith(isFinished: true);
  }

  // -----------------------------------------------------------------
  // 8️⃣ Increment helpers – UI calls these when the user taps “+rep”
  // -----------------------------------------------------------------
  void incrementRep() {
    if (state.isFinished || state.isPaused) return;
    state = state.copyWith(repCount: state.repCount + 1);
    // Optionally auto‑complete the set if we just hit the target.
    final ex = state.currentExercise;
    if (ex != null) {
      final target = _targetRepsForSet(ex, state.setIndex);
      if (state.repCount >= target) {
        completeSet();
      }
    }
  }

  // -----------------------------------------------------------------
  // 9️⃣ Dispose – call when the widget is removed from the tree
  // -----------------------------------------------------------------
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// 10️⃣ Provider definition – a StateNotifierProvider that reads the selected
//     workout from `selectedWorkoutProvider`.
// ---------------------------------------------------------------------------
final workoutSessionProvider =
    StateNotifierProvider<WorkoutSessionNotifier, WorkoutSessionState>((ref) {
  final workout = ref.watch(selectedWorkoutProvider);
  if (workout == null) {
    throw StateError('No workout selected – cannot create WorkoutSessionNotifier');
  }
  return WorkoutSessionNotifier(ref, workout);
});

// ---------------------------------------------------------------------------
// 11️⃣ Helper provider that holds the workout the user tapped on in the
//     workout‑list screen. (You can replace this with your existing method
//     of passing data via routes – e.g., using GoRouter’s `extra` field.)//
// ---------------------------------------------------------------------------
final selectedWorkoutProvider = StateProvider<CustomWorkout?>((ref) => null);