import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

/// Interactive daily water tracker.
///
/// Tapping glass N sets the count to N+1; tapping the last filled glass
/// removes it (undo). [onChanged] reports the new count for persistence.
class WaterTracker extends StatelessWidget {
  final int current;
  final int goal;
  final ValueChanged<int>? onChanged;

  const WaterTracker({
    super.key,
    required this.current,
    required this.goal,
    this.onChanged,
  });

  void _onGlassTap(int index) {
    if (onChanged == null) return;
    HapticHelper.light();
    final int tapped = index + 1;
    // Tapping the last filled glass empties it; anything else fills up to it.
    onChanged!(tapped == current ? index : tapped);
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              Icon(
                Icons.water_drop,
                color: AppColors.info,
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
                  color: AppTextColors.secondary,
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
                  child: Semantics(
                    button: true,
                    label: 'Glass ${index + 1} of $goal',
                    child: GestureDetector(
                      onTap: () => _onGlassTap(index),
                      child: AnimatedContainer(
                        duration: AppDurations.quick,
                        curve: Curves.easeOutCubic,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: index < current
                              ? AppColors.info
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppRadius.radiusSmall),
                          border: Border.all(
                            color: AppColors.outline,
                            width: 1,
                          ),
                        ),
                        child: index < current
                            ? Icon(
                                Icons.water_drop,
                                color: AppColors.onSecondary,
                                size: 16.sp,
                              )
                            : null,
                      ),
                    ),
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
