import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/animated_progress_bar.dart';

class MacroBreakdown extends StatelessWidget {
  final int protein;
  final int proteinGoal;
  final int carbs;
  final int carbsGoal;
  final int fat;
  final int fatGoal;

  const MacroBreakdown({
    super.key,
    required this.protein,
    required this.proteinGoal,
    required this.carbs,
    required this.carbsGoal,
    required this.fat,
    required this.fatGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MacroItem(
            label: 'Protein',
            current: protein,
            goal: proteinGoal,
            unit: 'g',
            color: AppColors.success,
          ),
        ),
        SizedBox(width: AppSpacing.space12.w),
        Expanded(
          child: _MacroItem(
            label: 'Carbs',
            current: carbs,
            goal: carbsGoal,
            unit: 'g',
            color: AppColors.warning,
          ),
        ),
        SizedBox(width: AppSpacing.space12.w),
        Expanded(
          child: _MacroItem(
            label: 'Fat',
            current: fat,
            goal: fatGoal,
            unit: 'g',
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final String unit;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.current,
    required this.goal,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / goal;
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            '$current$unit',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            'of $goal$unit',
            style: AppTypography.labelSmall.copyWith(
              color: AppTextColors.tertiary,
            ),
          ),
          SizedBox(height: AppSpacing.space12.h),
          AnimatedProgressBar(
            value: progress,
            minHeight: 4.h,
            backgroundColor: AppColors.outline,
            color: color,
          ),
        ],
      ),
    );
  }
}
