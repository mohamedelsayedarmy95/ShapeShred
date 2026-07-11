import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class StatsGrid extends StatelessWidget {
  final int workouts;
  final int streak;
  final int calories;
  final int minutes;

  const StatsGrid({
    super.key,
    required this.workouts,
    required this.streak,
    required this.calories,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.fitness_center,
            value: '$workouts',
            label: 'Workouts',
          ),
        ),
        SizedBox(width: AppSpacing.space12.w),
        Expanded(
          child: _StatItem(
            icon: Icons.local_fire_department,
            value: '$streak',
            label: 'Day Streak',
            highlight: true,
          ),
        ),
      ],
    ).let((row) => Column(
          children: [
            row,
            SizedBox(height: AppSpacing.space12.h),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_fire_department_outlined,
                    value: _formatNumber(calories),
                    label: 'Calories',
                  ),
                ),
                SizedBox(width: AppSpacing.space12.w),
                Expanded(
                  child: _StatItem(
                    icon: Icons.timer_outlined,
                    value: '${(minutes / 60).toStringAsFixed(0)}h',
                    label: 'Minutes',
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return '$number';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: highlight ? null : Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: highlight ? AppColors.onPrimary : AppTextColors.secondary,
            size: 24.sp,
          ),
          SizedBox(height: AppSpacing.space12.h),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: highlight ? AppColors.onPrimary : AppTextColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.space2.h),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: highlight
                  ? AppColors.onPrimary.withValues(alpha: 0.7)
                  : AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
