import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';

class Exercise {
  final String id;
  final String name;
  final int duration; // in seconds
  final int restDuration; // in seconds
  final String description;
  final IconData icon;
  final String? videoUrl;
  final List<String> tips;

  Exercise({
    required this.id,
    required this.name,
    required this.duration,
    required this.restDuration,
    required this.description,
    required this.icon,
    this.videoUrl,
    this.tips = const [],
  });
}

class Workout {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final int calories;
  final String level;
  final String category;
  final IconData icon;
  final Color color;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.calories,
    required this.level,
    required this.category,
    required this.icon,
    required this.color,
    required this.exercises,
  });
}

// Sample workout data
class WorkoutRepository {
  static final Workout hiitCardioBlast = Workout(
    id: 'hiit_cardio_blast',
    title: 'HIIT Cardio Blast',
    description:
        'High-intensity interval training to boost your metabolism and burn calories fast.',
    duration: 20,
    calories: 250,
    level: 'High Intensity',
    category: 'HIIT',
    icon: Icons.flash_on,
    color: AppColorPalette.absoluteBlack,
    exercises: [
      Exercise(
        id: 'jumping_jacks',
        name: 'Jumping Jacks',
        duration: 45,
        restDuration: 15,
        description: 'Full body cardio exercise',
        icon: Icons.accessibility_new,
        tips: [
          'Keep your core tight',
          'Land softly on your feet',
          'Maintain a steady rhythm',
        ],
      ),
      Exercise(
        id: 'burpees',
        name: 'Burpees',
        duration: 30,
        restDuration: 30,
        description: 'Full body explosive movement',
        icon: Icons.fitness_center,
        tips: [
          'Keep your back straight',
          'Explode up on the jump',
          'Control the landing',
        ],
      ),
      Exercise(
        id: 'mountain_climbers',
        name: 'Mountain Climbers',
        duration: 40,
        restDuration: 20,
        description: 'Core and cardio combination',
        icon: Icons.self_improvement,
        tips: [
          'Keep hips level',
          'Drive knees to chest',
          'Maintain plank position',
        ],
      ),
      Exercise(
        id: 'high_knees',
        name: 'High Knees',
        duration: 30,
        restDuration: 30,
        description: 'Cardio and leg strength',
        icon: Icons.directions_run,
        tips: [
          'Drive knees up high',
          'Pump your arms',
          'Stay on your toes',
        ],
      ),
    ],
  );

  static List<Workout> getAllWorkouts() {
    return [hiitCardioBlast];
  }
}
