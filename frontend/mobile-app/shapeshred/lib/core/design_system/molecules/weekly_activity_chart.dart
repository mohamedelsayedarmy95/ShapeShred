import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';

/// Premium weekly activity bar chart.
/// [values] are normalized 0.0-1.0, one per [labels] entry (typically Mon-Sun).
/// [todayIndex] renders that bar with the hero gradient; the rest use a muted fill.
class WeeklyActivityChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final int todayIndex;
  final double height;

  const WeeklyActivityChart({
    super.key,
    required this.values,
    required this.labels,
    required this.todayIndex,
    this.height = 120,
  }) : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: SizedBox(
        height: height.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(values.length, (index) {
            final isToday = index == todayIndex;
            final clamped = values[index].clamp(0.0, 1.0);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: clamped),
                          duration: AppDurations.cinematic,
                          curve: AppCurves.premiumFluid,
                          builder: (context, animatedValue, child) {
                            return FractionallySizedBox(
                              heightFactor: animatedValue <= 0 ? 0.03 : animatedValue,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.radiusTiny),
                                  gradient: isToday
                                      ? LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: AppColors.heroGradient,
                                        )
                                      : null,
                                  color: isToday
                                      ? null
                                      : AppColors.primary.withValues(alpha: 0.18),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8.h),
                    Text(
                      labels[index],
                      style: AppTypography.labelSmall.copyWith(
                        color: isToday ? AppColors.primary : AppTextColors.tertiary,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
