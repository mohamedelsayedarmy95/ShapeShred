import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_detail/workout_detail_page.dart';

class WorkoutListItem extends StatelessWidget {
  final Map<String, dynamic> workout;

  const WorkoutListItem({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => WorkoutDetailPage(
              workout: WorkoutRepository.hiitCardioBlast,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.cardPadding.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: (workout['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                workout['icon'] as IconData,
                color: workout['color'] as Color,
                size: 28.sp,
              ),
            ),
            
            SizedBox(width: AppSpacing.space16.w),
            
            // Workout Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout['title'] as String,
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
                        workout['duration'] as String,
                        style: AppTypography.bodySmall,
                      ),
                      SizedBox(width: AppSpacing.space12.w),
                      Icon(
                        Icons.fitness_center,
                        size: 14.sp,
                        color: AppTextColors.secondary,
                      ),
                      SizedBox(width: AppSpacing.space4.w),
                      Text(
                        '${workout['exercises']} exercises',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space8.w,
                      vertical: AppSpacing.space2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                    ),
                    child: Text(
                      workout['level'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppTextColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppTextColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
