import 'package:shapeshred/features/training/domain/models/exercise.dart';

class ExerciseRepository {
  static final List<Exercise> exercises = [
    // Chest Exercises
    Exercise(
      id: 'push_ups',
      name: 'Push Ups',
      category: 'Strength',
      description: 'Classic bodyweight exercise for chest, shoulders, and triceps.',
      muscleGroup: 'Chest',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Start in a plank position with hands shoulder-width apart',
        'Lower你的 body until chest nearly touches the floor',
        'Push back up to starting position',
        'Keep your core tight throughout',
      ],
    ),
    Exercise(
      id: 'chest_press',
      name: 'Chest Press',
      category: 'Strength',
      description: 'Compound exercise targeting the chest muscles.',
      muscleGroup: 'Chest',
      equipment: 'Dumbbells',
      difficulty: 'Intermediate',
      duration: 60,
      instructions: [
        'Lie on a bench holding dumbbells at chest level',
        'Press the weights up until arms are fully extended',
        'Lower the weights back to chest level',
        'Control the movement throughout',
      ],
    ),
    Exercise(
      id: 'chest_fly',
      name: 'Chest Fly',
      category: 'Strength',
      description: 'Isolation exercise for chest muscles.',
      muscleGroup: 'Chest',
      equipment: 'Dumbbells',
      difficulty: 'Intermediate',
      duration: 60,
      instructions: [
        'Lie on a bench holding dumbbells above your chest',
        'Lower the weights out to the sides in an arc',
        'Bring the weights back together above your chest',
        'Keep a slight bend in your elbows',
      ],
    ),

    // Back Exercises
    Exercise(
      id: 'pull_ups',
      name: 'Pull Ups',
      category: 'Strength',
      description: 'Upper body pulling exercise for back and biceps.',
      muscleGroup: 'Back',
      equipment: 'Pull-up Bar',
      difficulty: 'Advanced',
      duration: 45,
      instructions: [
        'Hang from the bar with an overhand grip',
        'Pull your body up until chin clears the bar',
        'Lower back down with control',
        'Avoid swinging or kipping',
      ],
    ),
    Exercise(
      id: 'rows',
      name: 'Dumbbell Rows',
      category: 'Strength',
      description: 'Unilateral back exercise for strength and balance.',
      muscleGroup: 'Back',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      duration: 60,
      instructions: [
        'Bend over with one hand on a bench for support',
        'Pull the dumbbell toward your hip',
        'Lower the weight with control',
        'Keep your back straight throughout',
      ],
    ),
    Exercise(
      id: 'lat_pulldown',
      name: 'Lat Pulldown',
      category: 'Strength',
      description: 'Machine exercise for latissimus dorsi development.',
      muscleGroup: 'Back',
      equipment: 'Cable Machine',
      difficulty: 'Beginner',
      duration: 60,
      instructions: [
        'Sit at the machine and grip the bar wide',
        'Pull the bar down to your upper chest',
        'Control the weight back up',
        'Keep your chest up and shoulders down',
      ],
    ),

    // Leg Exercises
    Exercise(
      id: 'squats',
      name: 'Squats',
      category: 'Strength',
      description: 'Fundamental lower body exercise for legs and glutes.',
      muscleGroup: 'Legs',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 60,
      instructions: [
        'Stand with feet shoulder-width apart',
        'Lower your body as if sitting in a chair',
        'Keep your chest up and knees tracking over toes',
        'Push through your heels to stand back up',
      ],
    ),
    Exercise(
      id: 'lunges',
      name: 'Lunges',
      category: 'Strength',
      description: 'Unilateral leg exercise for balance and strength.',
      muscleGroup: 'Legs',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 60,
      instructions: [
        'Step forward with one leg',
        'Lower your hips until both knees are at 90 degrees',
        'Push back to starting position',
        'Alternate legs for each rep',
      ],
    ),
    Exercise(
      id: 'deadlift',
      name: 'Deadlift',
      category: 'Strength',
      description: 'Compound exercise for posterior chain strength.',
      muscleGroup: 'Legs',
      equipment: 'Barbell',
      difficulty: 'Advanced',
      duration: 90,
      instructions: [
        'Stand with feet hip-width apart, bar over mid-foot',
        'Bend at hips and knees to grip the bar',
        'Keep your back straight and drive through heels',
        'Stand up straight with the bar',
      ],
    ),

    // Shoulder Exercises
    Exercise(
      id: 'shoulder_press',
      name: 'Shoulder Press',
      category: 'Strength',
      description: 'Overhead pressing exercise for shoulder development.',
      muscleGroup: 'Shoulders',
      equipment: 'Dumbbells',
      difficulty: 'Intermediate',
      duration: 60,
      instructions: [
        'Start with dumbbells at shoulder height',
        'Press the weights overhead until arms are extended',
        'Lower back to starting position with control',
        'Avoid arching your back',
      ],
    ),
    Exercise(
      id: 'lateral_raises',
      name: 'Lateral Raises',
      category: 'Strength',
      description: 'Isolation exercise for side deltoids.',
      muscleGroup: 'Shoulders',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Stand holding dumbbells at your sides',
        'Raise the weights out to shoulder height',
        'Lower with control',
        'Keep a slight bend in your elbows',
      ],
    ),
    Exercise(
      id: 'front_raises',
      name: 'Front Raises',
      category: 'Strength',
      description: 'Isolation exercise for front deltoids.',
      muscleGroup: 'Shoulders',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Stand holding dumbbells in front of your thighs',
        'Raise the weights to shoulder height',
        'Lower with control',
        'Keep your core tight',
      ],
    ),

    // Arm Exercises
    Exercise(
      id: 'bicep_curls',
      name: 'Bicep Curls',
      category: 'Strength',
      description: 'Classic isolation exercise for biceps.',
      muscleGroup: 'Arms',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Stand holding dumbbells at your sides',
        'Curl the weights toward your shoulders',
        'Lower with control',
        'Keep your elbows stationary',
      ],
    ),
    Exercise(
      id: 'tricep_dips',
      name: 'Tricep Dips',
      category: 'Strength',
      description: 'Bodyweight exercise for triceps development.',
      muscleGroup: 'Arms',
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      duration: 45,
      instructions: [
        'Grip parallel bars or bench edge',
        'Lower your body by bending elbows',
        'Push back up to starting position',
        'Keep your elbows close to your body',
      ],
    ),
    Exercise(
      id: 'hammer_curls',
      name: 'Hammer Curls',
      category: 'Strength',
      description: 'Variation targeting brachialis and forearms.',
      muscleGroup: 'Arms',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Hold dumbbells with neutral grip',
        'Curl the weights toward your shoulders',
        'Lower with control',
        'Keep palms facing each other',
      ],
    ),

    // Core Exercises
    Exercise(
      id: 'plank',
      name: 'Plank',
      category: 'Core',
      description: 'Isometric exercise for core stability.',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 60,
      instructions: [
        'Start in a forearm plank position',
        'Keep your body in a straight line',
        'Engage your core throughout',
        'Hold for the prescribed time',
      ],
    ),
    Exercise(
      id: 'crunches',
      name: 'Crunches',
      category: 'Core',
      description: 'Classic abdominal exercise.',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 45,
      instructions: [
        'Lie on your back with knees bent',
        'Curl your shoulders off the ground',
        'Lower back down with control',
        'Focus on contracting your abs',
      ],
    ),
    Exercise(
      id: 'leg_raises',
      name: 'Leg Raises',
      category: 'Core',
      description: 'Lower abdominal exercise.',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      duration: 60,
      instructions: [
        'Lie on your back with legs extended',
        'Raise your legs toward the ceiling',
        'Lower with control',
        'Keep your lower back pressed to the floor',
      ],
    ),

    // Cardio Exercises
    Exercise(
      id: 'jumping_jacks',
      name: 'Jumping Jacks',
      category: 'Cardio',
      description: 'Full-body cardio exercise.',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 30,
      instructions: [
        'Start with feet together, arms at sides',
        'Jump feet apart while raising arms overhead',
        'Jump back to starting position',
        'Maintain a steady rhythm',
      ],
    ),
    Exercise(
      id: 'burpees',
      name: 'Burpees',
      category: 'Cardio',
      description: 'High-intensity full-body exercise.',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      difficulty: 'Advanced',
      duration: 60,
      instructions: [
        'Start in a standing position',
        'Drop into a squat and place hands on ground',
        'Jump feet back into plank position',
        'Do a push-up, then jump feet back to hands',
        'Jump up explosively with arms overhead',
      ],
    ),
    Exercise(
      id: 'mountain_climbers',
      name: 'Mountain Climbers',
      category: 'Cardio',
      description: 'Dynamic core and cardio exercise.',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      duration: 45,
      instructions: [
        'Start in a plank position',
        'Drive one knee toward your chest',
        'Quickly alternate legs',
        'Keep your core tight and hips low',
      ],
    ),

    // Flexibility Exercises
    Exercise(
      id: 'stretching',
      name: 'Full Body Stretch',
      category: 'Flexibility',
      description: 'Comprehensive stretching routine.',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 120,
      instructions: [
        'Stretch each major muscle group',
        'Hold each stretch for 15-30 seconds',
        'Breathe deeply throughout',
        'Never bounce or force a stretch',
      ],
    ),
    Exercise(
      id: 'yoga_flow',
      name: 'Yoga Flow',
      category: 'Flexibility',
      description: 'Gentle yoga sequence for flexibility and relaxation.',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      duration: 180,
      instructions: [
        'Move through poses smoothly',
        'Focus on your breath',
        'Listen to your body',
        'Hold poses as comfortable',
      ],
    ),
  ];

  static List<Exercise> getByCategory(String category) {
    return exercises.where((e) => e.category == category).toList();
  }

  static List<Exercise> getByMuscleGroup(String muscleGroup) {
    return exercises.where((e) => e.muscleGroup == muscleGroup).toList();
  }

  static List<Exercise> getByDifficulty(String difficulty) {
    return exercises.where((e) => e.difficulty == difficulty).toList();
  }

  static Exercise? getById(String id) {
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> get categories => [
        'Strength',
        'Cardio',
        'Core',
        'Flexibility',
      ];

  static List<String> get muscleGroups => [
        'Chest',
        'Back',
        'Legs',
        'Shoulders',
        'Arms',
        'Core',
        'Full Body',
      ];

  static List<String> get difficulties => [
        'Beginner',
        'Intermediate',
        'Advanced',
      ];
}
