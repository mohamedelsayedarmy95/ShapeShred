import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/services/preferences_service.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String goal;
  final String fitnessLevel;
  final double? height;
  final double? weight;
  final int? age;
  final String? gender;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.goal,
    required this.fitnessLevel,
    this.height,
    this.weight,
    this.age,
    this.gender,
  });
}

class UserDataNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final displayName =
        user.displayName ?? user.email?.split('@')[0] ?? 'User';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final d = doc.data()!;
        return UserProfile(
          uid: user.uid,
          displayName: displayName,
          email: user.email ?? '',
          goal: d['goal'] as String? ?? '',
          fitnessLevel: d['fitnessLevel'] as String? ?? '',
          height: (d['height'] as num?)?.toDouble(),
          weight: (d['weight'] as num?)?.toDouble(),
          age: (d['age'] as num?)?.toInt(),
          gender: d['gender'] as String?,
        );
      }
    } catch (_) {}

    // Fallback: SharedPreferences
    return UserProfile(
      uid: user.uid,
      displayName: displayName,
      email: user.email ?? '',
      goal: await PreferencesService.getUserGoal() ?? '',
      fitnessLevel: await PreferencesService.getFitnessLevel() ?? '',
      height: await PreferencesService.getUserHeight(),
      weight: await PreferencesService.getUserWeight(),
      age: await PreferencesService.getUserAge(),
      gender: await PreferencesService.getUserGender(),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final userDataProvider =
    AsyncNotifierProvider<UserDataNotifier, UserProfile?>(
  UserDataNotifier.new,
);
