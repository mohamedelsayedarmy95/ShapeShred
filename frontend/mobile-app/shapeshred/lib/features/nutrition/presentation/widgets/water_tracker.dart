import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class WaterTracker extends StatelessWidget {
  final int current;
  final int goal;

  const WaterTracker({
    super.key,
    required this.current,
    required this.goal,
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
            children: [
              Icon(
                Icons.water_drop,
                color: AppColorPalette.gray700,
                size: 24.sp,
              ),
              SizedBox(width: AppSpacing.space8.w),
              Text(
                'Water Intake',
                style: AppTypography.titleMedium,
              ),
              const Spacer(),
              Text(
                '$current / $goal glasses',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColorPalette.gray700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space16.h),
          
          // Water Glasses
          Row(
            children: List.generate(
              goal,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: index < current 
                          ? AppColorPalette.gray900 
                          : AppColorPalette.gray100,
                      borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                      border: Border.all(
                        color: AppColorPalette.gray300,
                        width: 1,
                      ),
                    ),
                    child: index < current
                        ? Icon(
                            Icons.water_drop,
                            color: AppColorPalette.pureWhite,
                            size: 16.sp,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
