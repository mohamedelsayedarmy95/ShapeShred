import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/providers/firebase_providers.dart';

/// Immutable state that the workout-player UI reads.
class WorkoutSessionState {
  final bool isLoading;
  final CustomWorkout? workout;
  final int exerciseIndex; // 0-based
  final int setIndex; // 1-based
  final int repCount; // reps completed in the current set
  final bool isResting;
  final bool isPaused;
  final bool isFinished;
  final Duration elapsed; // active workout time, excluding rest
  final Map<String, dynamic> workoutLog;

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

  /// The exercise entry currently being performed, or null if out of range.
  WorkoutExercise? get currentExercise {
    final exercises = workout?.exercises;
    if (exercises == null || exerciseIndex >= exercises.length) return null;
    return exercises[exerciseIndex];
  }
}

/// Holds the workout the user tapped in the workout-list screen.
class SelectedWorkoutNotifier extends Notifier<CustomWorkout?> {
  @override
  CustomWorkout? build() => null;

  void select(CustomWorkout? workout) => state = workout;
}

final selectedWorkoutProvider =
    NotifierProvider<SelectedWorkoutNotifier, CustomWorkout?>(
        SelectedWorkoutNotifier.new);

/// Drives a live workout session: timers, set/rep progression, persistence.
class WorkoutSessionNotifier extends Notifier<WorkoutSessionState> {
  Timer? _tickTimer;
  Timer? _restTimer;
  DateTime? _sessionStart;

  @override
  WorkoutSessionState build() {
    ref.onDispose(_stopTimers);

    final workout = ref.watch(selectedWorkoutProvider);
    if (workout == null) {
      // No selection (e.g. it was just reset after finishing a workout):
      // stay idle instead of throwing; the player is only shown after a
      // workout is selected, which rebuilds this provider with real state.
      return const WorkoutSessionState();
    }

    final userId = ref.read(workoutUserIdProvider);
    _startWorkoutClock(Duration.zero);
    return WorkoutSessionState(
      isLoading: false,
      workout: workout,
      workoutLog: {
        'userId': userId,
        'name': workout.name,
        'exercises': <Map<String, dynamic>>[],
        'totalDuration': 0,
        'totalCalories': 0,
        'completedAt': null,
      },
    );
  }

  void _startWorkoutClock(Duration alreadyElapsed) {
    _stopTimers();
    _sessionStart = DateTime.now().subtract(alreadyElapsed);
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && !state.isFinished && !state.isResting) {
        state =
            state.copyWith(elapsed: DateTime.now().difference(_sessionStart!));
      }
    });
  }

  void _stopTimers() {
    _tickTimer?.cancel();
    _restTimer?.cancel();
    _tickTimer = null;
    _restTimer = null;
  }

  /// Ensure the session is running (e.g. after the Start button).
  void startExercise() {
    if (state.isPaused) {
      state = state.copyWith(isPaused: false);
    }
  }

  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
  }

  void resumeWorkout() {
    state = state.copyWith(isPaused: false);
    // Re-anchor the clock so elapsed time doesn't jump over the pause.
    _sessionStart = DateTime.now().subtract(state.elapsed);
  }

  /// Advance to the next set / exercise once the target reps are reached.
  void completeSet() {
    final ex = state.currentExercise;
    if (ex == null) return;

    if (state.repCount >= ex.reps) {
      if (state.setIndex < ex.sets) {
        state = state.copyWith(
          setIndex: state.setIndex + 1,
          repCount: 0,
          isResting: true,
        );
        _startRestTimer();
      } else {
        _advanceToNextExercise();
      }
    }
  }

  /// Skip the current exercise entirely.
  void skipExercise() => _advanceToNextExercise();

  void _advanceToNextExercise() {
    final nextIdx = state.exerciseIndex + 1;
    final total = state.workout?.exercises.length ?? 0;
    if (nextIdx < total) {
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

  void skipRest() {
    _stopRestTimer();
    state = state.copyWith(isResting: false);
  }

  void _startRestTimer() {
    const restDuration = Duration(seconds: 30);
    _stopRestTimer();
    _restTimer = Timer(restDuration, () {
      state = state.copyWith(isResting: false, repCount: 0);
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    _restTimer = null;
  }

  Future<void> _finishWorkout() async {
    _stopTimers();

    final log = Map<String, dynamic>.from(state.workoutLog)
      ..['totalDuration'] = state.elapsed.inSeconds
      ..['completedAt'] = FieldValue.serverTimestamp();

    try {
      final repo = ref.read(workoutHistoryRepositoryProvider);
      await repo.saveWorkout(log);
    } catch (e) {
      debugPrint('Failed to save workout: $e');
    }

    state = state.copyWith(isFinished: true);
  }

  /// Called by the UI when the user taps "- rep".
  void decrementRep() {
    if (state.isFinished || state.isPaused || state.repCount == 0) return;
    state = state.copyWith(repCount: state.repCount - 1);
  }

  /// Called by the UI when the user taps "+ rep".
  void incrementRep() {
    if (state.isFinished || state.isPaused) return;
    state = state.copyWith(repCount: state.repCount + 1);
    final ex = state.currentExercise;
    if (ex != null && state.repCount >= ex.reps) {
      completeSet();
    }
  }
}

final workoutSessionProvider =
    NotifierProvider<WorkoutSessionNotifier, WorkoutSessionState>(
        WorkoutSessionNotifier.new);
