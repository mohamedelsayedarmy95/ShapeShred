import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/features/training/data/workout_history_repository.dart';

// Firebase providers
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Stream of auth state changes
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Provider that yields the current user ID (String or null).
// Falls back to FirebaseAuth.currentUser because the auth stream has not
// emitted yet on a cold first read (it starts in AsyncLoading).
final workoutUserIdProvider = Provider<String?>((ref) {
  return ref.watch(firebaseUserProvider).value?.uid ??
      ref.watch(firebaseAuthProvider).currentUser?.uid;
});

// Provider for the workout history repository
final workoutHistoryRepositoryProvider =
    Provider<WorkoutHistoryRepository>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final userId = ref.watch(workoutUserIdProvider);
  if (userId == null) {
    throw StateError('User not authenticated');
  }
  return FirebaseWorkoutHistoryRepository(
    firestore: firestore,
    userId: userId,
  );
});
