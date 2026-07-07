import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

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
          colors: [AppColorPalette.gray900, AppColorPalette.gray700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColorPalette.gray900.withValues(alpha: 0.2),
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
                  color: AppColorPalette.gray600,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  ' DAILY CALORIES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColorPalette.pureWhite,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.local_fire_department,
                color: AppColorPalette.pureWhite,
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
                  color: AppColorPalette.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: AppSpacing.space8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  '/ $goal kcal',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColorPalette.gray300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            '$remaining kcal remaining',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColorPalette.gray400,
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: AppColorPalette.gray700,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColorPalette.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
