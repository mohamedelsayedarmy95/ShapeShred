import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class BodyMetricsCard extends StatelessWidget {
  final double weight;
  final double height;
  final double bmi;
  final double bodyFat;

  const BodyMetricsCard({
    super.key,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.bodyFat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColorPalette.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColorPalette.gray200),
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
                    Icons.monitor_heart_outlined,
                    color: AppColorPalette.gray900,
                    size: 22.sp,
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Text(
                    'Body Metrics',
                    style: AppTypography.titleMedium,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.edit_outlined,
                  color: AppColorPalette.gray500,
                  size: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space16.h),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Weight',
                  value: '$weight',
                  unit: 'kg',
                ),
              ),
              SizedBox(width: AppSpacing.space12.w),
              Expanded(
                child: _MetricItem(
                  label: 'Height',
                  value: '${height.toInt()}',
                  unit: 'cm',
                ),
              ),
              SizedBox(width: AppSpacing.space12.w),
              Expanded(
                child: _MetricItem(
                  label: 'BMI',
                  value: bmi.toStringAsFixed(1),
                  unit: _getBmiCategory(bmi),
                  highlight: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space12.h),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Body Fat',
                  value: '$bodyFat',
                  unit: '%',
                ),
              ),
              const Expanded(child: SizedBox()),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Under';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Over';
    return 'Obese';
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool highlight;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.unit,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space12.w),
      decoration: BoxDecoration(
        color: highlight ? AppColorPalette.gray900 : AppColorPalette.gray50,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: highlight ? AppColorPalette.gray300 : AppTextColor.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.titleMedium.copyWith(
                  color: highlight ? AppColorPalette.pureWhite : AppColorPalette.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  unit,
                  style: AppTypography.labelSmall.copyWith(
                    color: highlight ? AppColorPalette.gray400 : AppTextColor.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
