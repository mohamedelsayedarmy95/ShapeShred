import 'package:shapeshred/features/training/domain/models/exercise.dart';

class CustomWorkout {
  final String id;
  final String name;
  final String description;
  final String category;
  final int estimatedDuration; // in minutes
  final List<WorkoutExercise> exercises;
  final DateTime createdAt;

  CustomWorkout({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.estimatedDuration,
    required this.exercises,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomWorkout.fromJson(Map<String, dynamic> json) {
    return CustomWorkout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      estimatedDuration: json['estimatedDuration'] as int,
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final int? duration; // in seconds, for time-based exercises
  final int? weight; // in kg

  WorkoutExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    this.duration,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'weight': weight,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      duration: json['duration'] as int?,
      weight: json['weight'] as int?,
    );
  }
}
