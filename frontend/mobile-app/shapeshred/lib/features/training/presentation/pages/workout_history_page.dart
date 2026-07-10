import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'dart:math' as math;

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Not logged in')));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTextColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Workout History',
          style: AppTypography.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined, color: AppTextColors.primary),
            onPressed: () {
              HapticHelper.lightImpact();
              // Show analytics dialog or navigate to analytics page
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: Text(
                    'Workout Analytics',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: _buildAnalyticsOverview(context),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            _buildFilterChips(),
            SizedBox(height: AppSpacing.space16.h),

            // Analytics Overview
            _buildAnalyticsOverview(context),
            SizedBox(height: AppSpacing.space16.h),

            // Workout History List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('workout_history')
                    .orderBy('completedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  final workouts = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index].data() as Map<String, dynamic>;
                      return _buildWorkoutCard(workout, workouts[index].id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'This Week', 'This Month', 'Strength', 'Cardio'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.space8.w),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedFilter = filter);
                HapticHelper.lightImpact();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16.w,
                  vertical: AppSpacing.space12.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.outline,
                  ),
                ),
                child: Text(
                  filter,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout, String workoutId) {
    final completedAt = (workout['completedAt'] as Timestamp).toDate();
    final duration = workout['duration'] as int? ?? 0;
    final calories = workout['caloriesBurned'] as int? ?? 0;
    final exercises = workout['exercises'] as List? ?? [];
    final category = workout['category'] as String? ?? 'Workout';

    return GestureDetector(
      onTap: () {
        HapticHelper.lightImpact();
        _showWorkoutDetails(workout);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workout['name'] as String? ?? 'Workout',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space8.w,
                    vertical: AppSpacing.space4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                  ),
                  child: Text(
                    category,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.space12.h),

            // Date
            Text(
              '${_formatDate(completedAt)} at ${_formatTime(completedAt)}',
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColors.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),

            // Stats
            Row(
              children: [
                _buildStat(
                  icon: Icons.access_time,
                  label: '${duration}m',
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildStat(
                  icon: Icons.local_fire_department,
                  label: '$calories cal',
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildStat(
                  icon: Icons.fitness_center,
                  label: '${exercises.length} exercises',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppTextColors.secondary,
        ),
        SizedBox(width: AppSpacing.space4.w),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64.sp,
            color: AppTextColors.tertiary,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'No workout history yet',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            'Start working out to track your progress!',
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          final exercises = workout['exercises'] as List? ?? [];
          return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.radiusXL),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(AppSpacing.screenPadding.w),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  ),
                ),
              ),

              // Workout Name
              Text(
                workout['name'] as String? ?? 'Workout',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildDetailStat(
                      label: 'Duration',
                      value: '${workout['duration'] ?? 0} min',
                      icon: Icons.access_time,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space16.w),
                  Expanded(
                    child: _buildDetailStat(
                      label: 'Calories',
                      value: '${workout['caloriesBurned'] ?? 0} cal',
                      icon: Icons.local_fire_department,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Exercises
              Text(
                'Exercises',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              if (exercises.isEmpty)
                Text(
                  'No exercises recorded',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTextColors.secondary,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index] as Map<String, dynamic>;
                    return _buildExerciseItem(exercise);
                  },
                ),
              SizedBox(height: AppSpacing.space24.h),

              // Delete Button
              OutlinedButton.icon(
                onPressed: () {
                  HapticHelper.light();
                  _deleteWorkout(workout['id'] as String?);
                },
                icon: Icon(Icons.delete, color: AppColors.error),
                label: Text(
                  'Delete Entry',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildDetailStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: AppTextColors.secondary,
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Map<String, dynamic> exercise) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.space12.h),
      padding: EdgeInsets.all(AppSpacing.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise['name'] as String? ?? 'Exercise',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  '${exercise['sets'] ?? 0} sets × ${exercise['reps'] ?? 0} reps',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (exercise['completed'] == true)
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 20.sp,
            ),
        ],
      ),
    );
  }

  Future<void> _deleteWorkout(String? workoutId) async {
    if (workoutId == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workout_history')
          .doc(workoutId)
          .delete();

      if (mounted) {
        HapticHelper.successImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Workout deleted',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete workout: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildAnalyticsOverview(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getWorkoutAnalyticsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 100.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            height: 100.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Card(
              color: AppColors.surfaceVariant,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'Unable to load analytics data',
                  style: TextStyle(
                    color: AppTextColors.secondary,
                  ),
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!;

        // Determine trend icon and color
        IconData trendIcon;
        Color trendColor;
        String trendText;

        switch (data['trend']) {
          case 'improving':
            trendIcon = Icons.trending_up;
            trendColor = AppColors.success;
            trendText = 'Improving';
            break;
          case 'declining':
            trendIcon = Icons.trending_down;
            trendColor = AppColors.error;
            trendText = 'Declining';
            break;
          case 'plateau':
            trendIcon = Icons.show_chart;
            trendColor = AppColors.warning;
            trendText = 'Plateau';
            break;
          default:
            trendIcon = Icons.analytics;
            trendColor = AppColors.info;
            trendText = 'Insufficient Data';
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: trendColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendIcon,
                          size: 20.sp,
                          color: trendColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          trendText,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: trendColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnalyticsMetric(
                    'Workout Score',
                    '${data['score']}%',
                    Icons.star,
                    (data['score'] as int) >= 80
                        ? AppColors.success
                        : (data['score'] as int) >= 60
                            ? AppColors.warning
                            : AppColors.error,
                  ),
                  _buildAnalyticsMetric(
                    'Consistency',
                    '${data['consistency']}%',
                    Icons.calendar_today,
                    (data['consistency'] as int) >= 80
                        ? AppColors.success
                        : (data['consistency'] as int) >= 60
                            ? AppColors.warning
                            : AppColors.error,
                  ),
                  _buildAnalyticsMetric(
                    'Strength Trend',
                    data['strengthTrend'] as String,
                    Icons.fitness_center,
                    (data['strengthTrend'] as String) == 'increasing'
                        ? AppColors.success
                        : (data['strengthTrend'] as String) == 'decreasing'
                            ? AppColors.error
                            : AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsMetric(String label, dynamic value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: color,
        ),
        SizedBox(height: 4.h),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _getWorkoutAnalyticsData() async {
    // In a real app, this would fetch actual workout data from Firestore
    // and use the AdvancedAnalyticsService to process it
    // For demo purposes, we're returning mock data based on some randomness

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    final random = math.Random();

    // Simulate some variability in the data
    final bool isImproving = random.nextBool();
    final bool isConsistent = random.nextBool();
    final bool strengthIncreasing = random.nextBool();

    return {
      'trend': isImproving ? 'improving' : (!isConsistent ? 'declining' : 'plateau'),
      'score': 60 + random.nextInt(40), // 60-100
      'consistency': 50 + random.nextInt(50), // 50-100
      'strengthTrend': strengthIncreasing ? 'increasing' : 'decreasing',
    };
  }
}
