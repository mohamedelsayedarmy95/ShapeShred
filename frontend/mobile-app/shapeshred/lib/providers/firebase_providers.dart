import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/features/training/data/workout_history_repository.dart';

// Firebase providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Stream of auth state changes
final firebaseUserProvider = Stream<User?>( (ref) {
  return ref.read(firebaseAuthProvider).authStateChanges();
});

// Provider that yields the current user ID (String or null)
final workoutUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(firebaseUserProvider);
  return user?.uid;
});

// Provider for the workout history repository
final workoutHistoryRepositoryProvider = Provider<WorkoutHistoryRepository>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final userId = ref.watch(workoutUserIdProvider);
  if (userId == null) {
    throw StateException('User not authenticated');
  }
  return WorkoutHistoryRepository(
    firestore: firestore,
    userId: userId,
  );
});