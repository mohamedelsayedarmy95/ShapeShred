import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/skeleton_loader.dart';
import 'package:shapeshred/features/training/presentation/widgets/category_filter.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_list_item.dart';
import 'package:shapeshred/providers/user_data_provider.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
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
      'color': AppColors.chartColors[0],
    },
    {
      'title': 'Full Body Strength',
      'duration': '35 min',
      'exercises': 12,
      'level': 'Intermediate',
      'category': 'Strength',
      'icon': Icons.fitness_center,
      'color': AppColors.chartColors[1],
    },
    {
      'title': 'Morning Yoga Flow',
      'duration': '25 min',
      'exercises': 10,
      'level': 'Beginner',
      'category': 'Yoga',
      'icon': Icons.self_improvement,
      'color': AppColors.chartColors[2],
    },
    {
      'title': 'Core Crusher',
      'duration': '15 min',
      'exercises': 6,
      'level': 'Advanced',
      'category': 'HIIT',
      'icon': Icons.bolt,
      'color': AppColors.chartColors[4],
    },
    {
      'title': 'Upper Body Power',
      'duration': '30 min',
      'exercises': 10,
      'level': 'Intermediate',
      'category': 'Strength',
      'icon': Icons.fitness_center,
      'color': AppColors.chartColors[1],
    },
    {
      'title': 'Pilates Core',
      'duration': '20 min',
      'exercises': 8,
      'level': 'All Levels',
      'category': 'Pilates',
      'icon': Icons.accessibility_new,
      'color': AppColors.chartColors[2],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ref.read(userDataProvider.future);
      if (profile != null && mounted) {
        _userName = profile.displayName;
        _userGoal = profile.goal;
        _userFitnessLevel = profile.fitnessLevel;
      }
      if (_userGoal == 'Lose Weight' || _userGoal == 'Endurance') {
        _selectedCategory = 'Cardio';
      } else if (_userGoal == 'Build Muscle') {
        _selectedCategory = 'Strength';
      } else {
        _selectedCategory = 'All';
      }
    } catch (e) {
      debugPrint('TrainingPage: error loading data: $e');
      _selectedCategory = 'All';
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding.w,
              vertical: AppSpacing.space16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 200.w, height: 30.h),
                SizedBox(height: AppSpacing.space8.h),
                SkeletonLoader(width: 240.w, height: 16.h),
                SizedBox(height: AppSpacing.space20.h),
                Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: AppSpacing.space8.w),
                      child: SkeletonLoader(
                        width: 72.w,
                        height: 36.h,
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusPill),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space20.h),
                const Expanded(child: SkeletonList()),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    AppLocalizations.of(context)!.helloUser(_userName),
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppTextColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    AppLocalizations.of(context)!.findPerfectWorkout,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColors.secondary,
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
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSpacing.space12.h),
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return _StaggeredEntry(
                    key: ValueKey('$_selectedCategory-${workout['title']}'),
                    index: index,
                    child: WorkoutListItem(workout: workout),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fades and slides a list item in, staggered by [index] relative to its siblings.
class _StaggeredEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredEntry({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.standard +
          Duration(milliseconds: index * AnimationStaggerConfig.delay),
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
