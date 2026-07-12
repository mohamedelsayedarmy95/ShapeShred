import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/atoms/skeleton_loader.dart';
import 'package:shapeshred/core/design_system/molecules/stat_card.dart';
import 'package:shapeshred/core/design_system/molecules/workout_card.dart';
import 'package:shapeshred/core/design_system/molecules/weekly_activity_chart.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/providers/firebase_providers.dart';
import 'package:shapeshred/providers/workout_session_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _userName = 'User';
  String _userEmail = '';
  String _userGoal = '';
  String _userFitnessLevel = '';
  bool _isLoading = true;
  CustomWorkout? _todaysWorkout;
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user != null) {
        // Try to get data from Firestore first
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          setState(() {
            _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
            _userEmail = user.email ?? '';
            _userGoal = data['goal'] as String? ?? '';
            _userFitnessLevel = data['fitnessLevel'] as String? ?? '';
          });
        } else {
          // Fallback to SharedPreferences for goal and fitness level only
          _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
          _userEmail = user.email ?? '';
          _userGoal = await PreferencesService.getUserGoal() ?? '';
          _userFitnessLevel = await PreferencesService.getFitnessLevel() ?? '';
        }
      }

      // Load today's workout based on goal and fitness level
      _todaysWorkout = _getTodaysWorkout(_userGoal, _userFitnessLevel);

      // Load stats (mock for now, will be replaced with real data)
      _stats = _getMockStats();

      // Load recommendations based on goal and fitness level
      _recommendations = _getRecommendations(_userGoal, _userFitnessLevel);
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Fallback to defaults
      final user = ref.read(firebaseAuthProvider).currentUser;
      _userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
      _userEmail = user?.email ?? '';
      _userGoal = '';
      _userFitnessLevel = '';
      _todaysWorkout = _getTodaysWorkout('', '');
      _stats = _getMockStats();
      _recommendations = _getRecommendations('', '');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  CustomWorkout _getTodaysWorkout(String goal, String fitnessLevel) {
    // Define exercises
    final List<Exercise> hiitExercises = [
      Exercise(
        id: 'jumping_jacks',
        name: 'Jumping Jacks',
        category: 'Cardio',
        description: 'Classic jumping jacks',
        muscleGroup: 'Full Body',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        duration: 30,
        instructions: [
          'Jump feet out while raising arms overhead',
          'Return to starting position'
        ],
      ),
      Exercise(
        id: 'mountain_climbers',
        name: 'Mountain Climbers',
        category: 'Cardio',
        description: 'Dynamic plank exercise',
        muscleGroup: 'Core',
        equipment: 'Bodyweight',
        difficulty: 'Intermediate',
        duration: 30,
        instructions: [
          'Start in plank position',
          'Alternate bringing knees to chest'
        ],
      ),
      Exercise(
        id: 'burpees',
        name: 'Burpees',
        category: 'Cardio',
        description: 'Full body explosive movement',
        muscleGroup: 'Full Body',
        equipment: 'Bodyweight',
        difficulty: 'Advanced',
        duration: 45,
        instructions: [
          'From standing, drop to push-up position',
          'Do a push-up, then jump back to standing'
        ],
      ),
    ];

    final List<Exercise> strengthExercises = [
      Exercise(
        id: 'push_ups',
        name: 'Push-Ups',
        category: 'Strength',
        description: 'Classic upper body exercise',
        muscleGroup: 'Chest, Shoulders, Triceps',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        duration: 30,
        instructions: [
          'Keep body straight',
          'Lower chest to floor',
          'Push back up'
        ],
      ),
      Exercise(
        id: 'squats',
        name: 'Squats',
        category: 'Strength',
        description: 'Lower body strength exercise',
        muscleGroup: 'Legs, Glutes',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        duration: 30,
        instructions: [
          'Feet shoulder-width apart',
          'Sit back and down',
          'Keep chest up'
        ],
      ),
      Exercise(
        id: 'plank',
        name: 'Plank',
        category: 'Strength',
        description: 'Core stability exercise',
        muscleGroup: 'Core',
        equipment: 'Bodyweight',
        difficulty: 'Intermediate',
        duration: 30,
        instructions: [
          'Stay on forearms and toes',
          'Keep body in straight line',
          'Engage core'
        ],
      ),
    ];

    final List<Exercise> yogaExercises = [
      Exercise(
        id: 'downward_dog',
        name: 'Downward Dog',
        category: 'Flexibility',
        description: 'Classic yoga pose',
        muscleGroup: 'Back, Hamstrings',
        equipment: 'None',
        difficulty: 'Beginner',
        duration: 45,
        instructions: [
          'Start on hands and knees',
          'Lift hips up and back',
          'Press heels toward floor'
        ],
      ),
      Exercise(
        id: 'warrior_ii',
        name: 'Warrior II',
        category: 'Strength',
        description: 'Standing yoga pose',
        muscleGroup: 'Legs, Core',
        equipment: 'None',
        difficulty: 'Beginner',
        duration: 45,
        instructions: [
          'Step feet wide apart',
          'Turn front foot out',
          'Bend front knee'
        ],
      ),
      Exercise(
        id: 'tree_pose',
        name: 'Tree Pose',
        category: 'Balance',
        description: 'Balance and focus pose',
        muscleGroup: 'Legs, Core',
        equipment: 'None',
        difficulty: 'Beginner',
        duration: 30,
        instructions: [
          'Stand on one foot',
          'Place opposite foot on inner thigh',
          'Bring hands to heart'
        ],
      ),
    ];

    // Default workout: balanced mix, so an unknown/empty goal still
    // yields a startable workout (empty exercises would crash the player).
    List<WorkoutExercise> exercises = [
      ...hiitExercises.take(1),
      ...strengthExercises.take(2),
    ].map((e) => WorkoutExercise(exercise: e, sets: 3, reps: 12)).toList();
    String title = 'Full Body Blast';
    String duration = '20 min';
    String level = 'Beginner';
    String category = 'General';
    IconData icon = Icons.fitness_center;

    // Adjust based on goal
    if (goal == 'Lose Weight') {
      exercises = hiitExercises
          .map((e) => WorkoutExercise(
                exercise: e,
                sets: 3,
                reps: 12,
              ))
          .toList();
      title = 'Fat Burning HIIT';
      duration = '25 min';
      level = 'Intermediate';
      category = 'HIIT';
      icon = Icons.local_fire_department;
    } else if (goal == 'Build Muscle') {
      exercises = strengthExercises
          .map((e) => WorkoutExercise(
                exercise: e,
                sets: 4,
                reps: 10,
              ))
          .toList();
      title = 'Strength & Hypertrophy';
      duration = '35 min';
      level = 'Intermediate';
      category = 'Strength';
      icon = Icons.fitness_center;
    } else if (goal == 'Endurance') {
      // Mix of cardio and light strength
      List<Exercise> enduranceExercises = [
        ...hiitExercises.take(2),
        ...strengthExercises.take(1)
      ];
      exercises = enduranceExercises
          .map((e) => WorkoutExercise(
                exercise: e,
                sets: 3,
                reps: 15,
              ))
          .toList();
      title = 'Endurance Builder';
      duration = '30 min';
      level = 'Intermediate';
      category = 'Endurance';
      icon = Icons.airplanemode_active;
    } else if (goal == 'Stay Fit') {
      // Balanced mix
      List<Exercise> mixedExercises = [
        ...hiitExercises.take(1),
        ...strengthExercises.take(1),
        ...yogaExercises.take(1)
      ];
      exercises = mixedExercises
          .map((e) => WorkoutExercise(
                exercise: e,
                sets: 3,
                reps: 12,
              ))
          .toList();
      title = 'Balanced Fitness';
      duration = '20 min';
      level = 'All Levels';
      category = 'General';
      icon = Icons.accessibility_new;
    }

    // Adjust based on fitness level
    if (fitnessLevel == 'Beginner') {
      // Reduce sets and reps for beginners
      exercises = exercises
          .map((e) => WorkoutExercise(
                exercise: e.exercise,
                sets: (e.sets * 0.8).round(),
                reps: (e.reps * 0.8).round(),
              ))
          .toList();
      if (level == 'Advanced') {
        level = 'Intermediate';
      } else if (level == 'Intermediate') level = 'Beginner';
    } else if (fitnessLevel == 'Advanced') {
      // Increase sets and reps for advanced
      exercises = exercises
          .map((e) => WorkoutExercise(
                exercise: e.exercise,
                sets: e.sets + 1,
                reps: e.reps + 5,
              ))
          .toList();
      if (level == 'Beginner') {
        level = 'Intermediate';
      } else if (level == 'Intermediate') level = 'Advanced';
    }

    return CustomWorkout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: title,
      description: 'Today\'s personalized workout based on your goals',
      category: category,
      estimatedDuration: int.parse(duration.replaceAll(' min', '')),
      exercises: exercises,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _getMockStats() {
    // In a real app, this would come from Firestore or a backend
    return {
      'caloriesBurned': 450,
      'workoutsCompleted': 12,
      'activeDays': 8,
      'weeklyActivity': [0.3, 0.65, 0.45, 0.9, 0.55, 0.2, 0.75],
    };
  }

  List<Map<String, dynamic>> _getRecommendations(
      String goal, String fitnessLevel) {
    // Base recommendations
    List<Map<String, dynamic>> recommendations = [
      {
        'title': 'Strength Training',
        'duration': '30 min',
        'level': 'Intermediate',
        'icon': Icons.fitness_center,
      },
      {
        'title': 'Yoga & Flexibility',
        'duration': '20 min',
        'level': 'Beginner',
        'icon': Icons.self_improvement,
      },
      {
        'title': 'Pilates Core',
        'duration': '25 min',
        'level': 'All Levels',
        'icon': Icons.accessibility_new,
      },
      {
        'title': 'HIIT Blast',
        'duration': '15 min',
        'level': 'All Levels',
        'icon': Icons.flash_on,
      },
    ];

    // Adjust based on goal
    if (goal == 'Lose Weight') {
      recommendations[0] = {
        'title': 'Fat Burn Cardio',
        'duration': '30 min',
        'level': 'Intermediate',
        'icon': Icons.local_fire_department,
      };
      recommendations[3] = {
        'title': 'Max Burn HIIT',
        'duration': '20 min',
        'level': 'Advanced',
        'icon': Icons.flash_on,
      };
    } else if (goal == 'Build Muscle') {
      recommendations[0] = {
        'title': 'Heavy Lifting',
        'duration': '40 min',
        'level': 'Advanced',
        'icon': Icons.fitness_center,
      };
      recommendations[2] = {
        'title': 'Advanced Core',
        'duration': '30 min',
        'level': 'Advanced',
        'icon': Icons.accessibility_new,
      };
    } else if (goal == 'Endurance') {
      recommendations[0] = {
        'title': 'Endurance Run',
        'duration': '45 min',
        'level': 'Intermediate',
        'icon': Icons.terrain,
      };
      recommendations[1] = {
        'title': 'Cycling Endurance',
        'duration': '30 min',
        'level': 'Intermediate',
        'icon': Icons.pedal_bike,
      };
    } else if (goal == 'Stay Fit') {
      // Keep default balanced
    }

    // Adjust based on fitness level
    if (fitnessLevel == 'Beginner') {
      for (var rec in recommendations) {
        final int duration =
            (int.parse((rec['duration'] as String).replaceAll(' min', '')) *
                    0.8)
                .round();
        rec['duration'] = '$duration min';
        if (rec['level'] == 'Advanced') {
          rec['level'] = 'Intermediate';
        } else if (rec['level'] == 'Intermediate') {
          rec['level'] = 'Beginner';
        }
      }
    } else if (fitnessLevel == 'Advanced') {
      for (var rec in recommendations) {
        final int duration =
            int.parse((rec['duration'] as String).replaceAll(' min', '')) + 10;
        rec['duration'] = '$duration min';
        if (rec['level'] == 'Beginner') {
          rec['level'] = 'Intermediate';
        } else if (rec['level'] == 'Intermediate') {
          rec['level'] = 'Advanced';
        }
      }
    }

    return recommendations;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  void _startWorkout() {
    if (_todaysWorkout == null) return;
    // Set the selected workout in the provider
    ref.read(selectedWorkoutProvider.notifier).select(_todaysWorkout);
    // Root-navigator route: full-screen player without the bottom bar.
    context.push('/super-ultra-premium-workout');
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: '🔥',
            value: _stats?['caloriesBurned'].toString() ?? '0',
            label: 'Calories Burned',
          ),
        ),
        SizedBox(width: AppSpacing.space12.w),
        Expanded(
          child: StatCard(
            icon: '💪',
            value: _stats?['workoutsCompleted'].toString() ?? '0',
            label: 'Workouts',
          ),
        ),
        SizedBox(width: AppSpacing.space12.w),
        Expanded(
          child: StatCard(
            icon: '📅',
            value: _stats?['activeDays'].toString() ?? '0',
            label: 'Active Days',
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCarousel() {
    return SizedBox(
      height: 200.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: _recommendations
            .map((rec) => Padding(
                  padding: EdgeInsets.only(right: AppSpacing.space12.w),
                  child: WorkoutCard(
                    title: rec['title'] as String,
                    duration: rec['duration'] as String,
                    level: rec['level'] as String,
                    icon: rec['icon'] as IconData,
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding.w,
              vertical: AppSpacing.space16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonLoader(width: 140.w, height: 32.h),
                    SkeletonLoader(
                      width: 44.w,
                      height: 44.h,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.space32.h),
                SkeletonCard(height: 220.h),
                SizedBox(height: AppSpacing.space32.h),
                const SkeletonStatsRow(),
                SizedBox(height: AppSpacing.space40.h),
                SkeletonLoader(width: 180.w, height: 22.h),
                SizedBox(height: AppSpacing.space16.h),
                SkeletonCard(height: 200.h),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.w,
            vertical: AppSpacing.space16.h,
          ),
          child: _FadeSlideIn(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                SizedBox(height: AppSpacing.space32.h),

                // Hero Card - Today's Workout
                _buildHeroCard(),
                SizedBox(height: AppSpacing.space32.h),

                // Stats Row
                _buildStatsRow(),
                SizedBox(height: AppSpacing.space32.h),

                // This Week Activity Chart
                Text(
                  'This Week',
                  style: AppTypography.headlineSmall,
                ),
                SizedBox(height: AppSpacing.space16.h),
                _buildWeeklyActivityChart(),
                SizedBox(height: AppSpacing.space40.h),

                // Section Title
                Text(
                  'Recommended for You',
                  style: AppTypography.headlineSmall,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Recommendations Carousel
                _buildRecommendationsCarousel(),
                SizedBox(height: AppSpacing.space32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyActivityChart() {
    final List<double> weekly = (_stats?['weeklyActivity'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        const [0, 0, 0, 0, 0, 0, 0];
    final todayIndex = (DateTime.now().weekday - 1).clamp(0, 6);
    return WeeklyActivityChart(
      values: weekly,
      labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
      todayIndex: todayIndex,
    );
  }

  Widget _buildHeader() {
    final String greeting = _getGreeting();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: AppTypography.bodyLarge.copyWith(
                color: AppTextColors.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              _userName,
              style: AppTypography.headlineMedium,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: Icon(
            Icons.notifications_none_outlined,
            color: AppTextColors.primary,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
            ),
            child: Text(
              '🔥 TODAY\'S WORKOUT',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onPrimary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),
          Text(
            _todaysWorkout?.name ?? 'Workout',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppColors.onPrimary.withValues(alpha: 0.8),
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                _todaysWorkout?.estimatedDuration.toString() ?? '20',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'min',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.fitness_center,
                color: AppColors.onPrimary.withValues(alpha: 0.8),
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                _todaysWorkout?.exercises.length.toString() ?? '0',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'exercises',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space24.h),
          GestureDetector(
            onTap: _startWorkout,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.onPrimary,
                borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
              ),
              child: Center(
                child: Text(
                  'START WORKOUT',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fades and slides its child up once, on first build after data loads.
class _FadeSlideIn extends StatelessWidget {
  final Widget child;

  const _FadeSlideIn({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.cinematic,
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
