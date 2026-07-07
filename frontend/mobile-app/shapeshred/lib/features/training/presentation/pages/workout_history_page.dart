import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

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
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorPalette.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Workout History',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            _buildFilterChips(),
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
                HapticHelper.light();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16.w,
                  vertical: AppSpacing.space12.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  border: Border.all(
                    color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
                  ),
                ),
                child: Text(
                  filter,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
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
        HapticHelper.light();
        _showWorkoutDetails(workout);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColorPalette.gray200),
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
                    color: AppColorPalette.gray100,
                    borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                  ),
                  child: Text(
                    category,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColorPalette.gray700,
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
                color: AppTextColor.secondary,
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
                  label: '${calories} cal',
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
          color: AppColorPalette.gray700,
        ),
        SizedBox(width: AppSpacing.space4.w),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColorPalette.gray700,
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
            color: AppColorPalette.gray300,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'No workout history yet',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            'Start working out to track your progress!',
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColorPalette.pureWhite,
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
                    color: AppColorPalette.gray200,
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

              final exercises = workout['exercises'] as List? ?? [];
              if (exercises.isEmpty)
                Text(
                  'No exercises recorded',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTextColor.secondary,
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
                icon: Icon(Icons.delete, color: AppColorPalette.error),
                label: Text(
                  'Delete Entry',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColorPalette.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColorPalette.error),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        color: AppColorPalette.gray50,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: AppColorPalette.gray700,
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
              color: AppTextColor.secondary,
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
        color: AppColorPalette.gray50,
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
                    color: AppTextColor.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (exercise['completed'] == true)
            Icon(
              Icons.check_circle,
              color: AppColorPalette.success,
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
        HapticHelper.success();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Workout deleted',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
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
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.error,
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
}
