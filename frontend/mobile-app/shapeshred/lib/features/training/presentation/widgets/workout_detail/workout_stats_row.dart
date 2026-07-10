import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class WorkoutStatsRow extends StatelessWidget {
  final int duration;
  final int calories;
  final int exercises;
  final String level;

  const WorkoutStatsRow({
    super.key,
    required this.duration,
    required this.calories,
    required this.exercises,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.timer_outlined,
              value: '$duration',
              label: 'Minutes',
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: AppColors.outline,
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department_outlined,
              value: '$calories',
              label: 'Calories',
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: AppColors.outline,
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.fitness_center,
              value: '$exercises',
              label: 'Exercises',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTextColors.secondary,
          size: 24.sp,
        ),
        SizedBox(height: AppSpacing.space8.h),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.space2.h),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }
}
