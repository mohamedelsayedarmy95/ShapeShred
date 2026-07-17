import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/animated_progress_bar.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class CaloriesHeroCard extends StatelessWidget {
  final int consumed;
  final int goal;

  const CaloriesHeroCard({
    super.key,
    required this.consumed,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = consumed / goal;
    final remaining = goal - consumed;

    return Container(
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                ),
                child: Text(
                  ' ${AppLocalizations.of(context)!.dailyCalories}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.local_fire_department,
                color: AppColors.onPrimary,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space24.h),

          // Calories Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$consumed',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: AppSpacing.space8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  '/ $goal kcal',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            '$remaining ${AppLocalizations.of(context)!.kcalRemaining}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),

          // Progress Bar
          AnimatedProgressBar(
            value: progress,
            minHeight: 8.h,
            backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
            color: AppColors.onPrimary,
          ),
        ],
      ),
    );
  }
}
