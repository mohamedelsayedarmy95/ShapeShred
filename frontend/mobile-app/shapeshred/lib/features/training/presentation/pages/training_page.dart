import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/training/presentation/widgets/category_filter.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_list_item.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _selectedCategory = 'All';

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

  List<Map<String, dynamic>> get _filteredWorkouts {
    if (_selectedCategory == 'All') {
      return _workouts;
    }
    return _workouts.where((w) => w['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
                vertical: AppSpacing.space16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training Library',
                    style: AppTypography.headlineLarge,
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  Text(
                    'Choose your workout',
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

