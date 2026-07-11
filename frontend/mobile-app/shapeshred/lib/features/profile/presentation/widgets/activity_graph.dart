import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class ActivityGraph extends StatelessWidget {
  final List<int> weeklyData;

  const ActivityGraph({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxValue = weeklyData.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.show_chart,
                    color: AppTextColors.primary,
                    size: 22.sp,
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Text(
                    'Weekly Activity',
                    style: AppTypography.titleMedium,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                ),
                child: Text(
                  'This Week',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space20.h),

          // Graph
          SizedBox(
            height: 140.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                7,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: index == 5
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.radiusSmall),
                            ),
                          ).let((bar) => FractionallySizedBox(
                                heightFactor: weeklyData[index] / maxValue,
                                child: bar,
                              )),
                        ),
                        SizedBox(height: AppSpacing.space8.h),
                        Text(
                          days[index],
                          style: AppTypography.labelSmall.copyWith(
                            color: index == 5
                                ? AppColors.primary
                                : AppTextColors.secondary,
                            fontWeight:
                                index == 5 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.space16.h),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: AppSpacing.space12.h),

          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryItem(
                label: 'Total',
                value: '${weeklyData.reduce((a, b) => a + b)} min',
              ),
              _SummaryItem(
                label: 'Average',
                value:
                    '${(weeklyData.reduce((a, b) => a + b) / 7).toStringAsFixed(0)} min',
              ),
              _SummaryItem(
                label: 'Best Day',
                value: '$maxValue min',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
        SizedBox(height: AppSpacing.space2.h),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
