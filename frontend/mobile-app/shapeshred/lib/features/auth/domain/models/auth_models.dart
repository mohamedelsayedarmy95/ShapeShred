import 'package:equatable/equatable.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
  });
}

class OnboardingData extends Equatable {
  final String? goal;
  final double? height;
  final double? weight;
  final int? age;
  final String? gender;
  final String? fitnessLevel;
  final List<String>? interests;

  const OnboardingData({
    this.goal,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.fitnessLevel,
    this.interests,
  });

  OnboardingData copyWith({
    String? goal,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? fitnessLevel,
    List<String>? interests,
  }) {
    return OnboardingData(
      goal: goal ?? this.goal,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      interests: interests ?? this.interests,
    );
  }

  @override
  List<Object?> get props => [goal, height, weight, age, gender, fitnessLevel, interests];
}
