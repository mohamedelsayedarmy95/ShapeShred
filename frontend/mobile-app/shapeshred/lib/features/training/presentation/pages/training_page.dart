import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/features/training/presentation/widgets/category_filter.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_list_item.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _selectedCategory = 'All';
  String _userName = 'User';
  String _userGoal = '';
  String _userFitnessLevel = '';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'HIIT',
    'Strength',
    'Yoga',
    'Cardio',
    'Pilates',
  ];

  final List<Map<String, dynamic>> _workouts = [
    {
      'title': 'HIIT Cardio Blast',
      'duration': '20 min',
      'exercises': 8,
      'level': 'High Intensity',
      'category': 'HIIT',
      'icon': Icons.flash_on,
      'color': AppColorPalette.gray900,
    },
    {
      'title': 'Full Body Strength',
      'duration': '35 min',
      'exercises': 12,
      'level': 'Intermediate',
      'category': 'Strength',
      'icon': Icons.fitness_center,
      'color': AppColorPalette.gray700,
    },
    {
      'title': 'Morning Yoga Flow',
      'duration': '25 min',
      'exercises': 10,
      'level': 'Beginner',
      'category': 'Yoga',
      'icon': Icons.self_improvement,
      'color': AppColorPalette.gray600,
    },
    {
      'title': 'Core Crusher',
      'duration': '15 min',
      'exercises': 6,
      'level': 'Advanced',
      'category': 'HIIT',
      'icon': Icons.bolt,
      'color': AppColorPalette.gray800,
    },
    {
      'title': 'Upper Body Power',
      'duration': '30 min',
      'exercises': 10,
      'level': 'Intermediate',
      'category': 'Strength',
      'icon': Icons.fitness_center,
      'color': AppColorPalette.gray700,
    },
    {
      'title': 'Pilates Core',
      'duration': '20 min',
      'exercises': 8,
      'level': 'All Levels',
      'category': 'Pilates',
      'icon': Icons.accessibility_new,
      'color': AppColorPalette.gray600,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
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
            _userGoal = data['goal'] ?? '';
            _userFitnessLevel = data['fitnessLevel'] ?? '';
          });
        } else {
          // Fallback to SharedPreferences for goal and fitness level
          _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
          _userGoal = await PreferencesService.getUserGoal() ?? '';
          _userFitnessLevel =
              await PreferencesService.getFitnessLevel() ?? '';
        }
      }

      // Set initial category based on goal
      if (_userGoal == 'Lose Weight') {
        _selectedCategory = 'Cardio';
      } else if (_userGoal == 'Build Muscle') {
        _selectedCategory = 'Strength';
      } else if (_userGoal == 'Endurance') {
        _selectedCategory = 'Cardio';
      } else if (_userGoal == 'Stay Fit') {
        _selectedCategory = 'All';
      } else {
        _selectedCategory = 'All';
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Fallback to defaults
      final user = FirebaseAuth.instance.currentUser;
      _userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
      _userGoal = '';
      _userFitnessLevel = '';
      _selectedCategory = 'All';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredWorkouts {
    if (_selectedCategory == 'All') {
      return _workouts;
    }
    return _workouts.where((w) => w['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColorPalette.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
                vertical: AppSpacing.space16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $_userName!',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColorPalette.gray900,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    'Let\'s find your perfect workout',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter
            CategoryFilter(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),

            SizedBox(height: AppSpacing.space16.h),

            // Workouts List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.w,
                ),
                itemCount: _filteredWorkouts.length,
                separatorBuilder: (context, index) => SizedBox(height: AppSpacing.space12.h),
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return WorkoutListItem(workout: workout);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}