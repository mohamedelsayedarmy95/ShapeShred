import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? fitnessLevel;
  final String? goal;
  final bool isPremium;
  final String? profileImageUrl;

  const UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel,
    this.goal,
    required this.isPremium,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        heightCm,
        weightKg,
        fitnessLevel,
        goal,
        isPremium,
        profileImageUrl,
      ];

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? fitnessLevel,
    String? goal,
    String? profileImageUrl,
  }) {
    return UserProfile(
      id: id,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goal: goal ?? this.goal,
      isPremium: isPremium,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
