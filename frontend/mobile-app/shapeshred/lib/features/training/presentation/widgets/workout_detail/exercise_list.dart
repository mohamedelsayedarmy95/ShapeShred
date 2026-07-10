import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';

class ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;

  const ExerciseList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        exercises.length,
        (index) => _ExerciseItem(
          exercise: exercises[index],
          index: index + 1,
          isLast: index == exercises.length - 1,
        ),
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final int index;
  final bool isLast;

  const _ExerciseItem({
    required this.exercise,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.cardPadding.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.space16.w),

              // Exercise Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14.sp,
                          color: AppTextColors.secondary,
                        ),
                        SizedBox(width: AppSpacing.space4.w),
                        Text(
                          '${exercise.duration}s',
                          style: AppTypography.bodySmall,
                        ),
                        SizedBox(width: AppSpacing.space12.w),
                        Icon(
                          Icons.pause_circle_outline,
                          size: 14.sp,
                          color: AppTextColors.secondary,
                        ),
                        SizedBox(width: AppSpacing.space4.w),
                        Text(
                          '${exercise.restDuration}s rest',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Play Icon
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) SizedBox(height: AppSpacing.space12.h),
      ],
    );
  }
}
