import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class MealListItem extends StatelessWidget {
  final String mealType;
  final String time;
  final int calories;
  final String items;
  final IconData icon;
  final bool isEmpty;

  const MealListItem({
    super.key,
    required this.mealType,
    required this.time,
    required this.calories,
    required this.items,
    required this.icon,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: isEmpty ? AppColors.surfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(
          color: AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isEmpty
                  ? AppColors.surfaceVariant
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
            ),
            child: Icon(
              isEmpty ? Icons.add : icon,
              color: isEmpty
                  ? AppTextColors.secondary
                  : AppColors.primary,
              size: 24.sp,
            ),
          ),
          
          SizedBox(width: AppSpacing.space16.w),
          
          // Meal Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mealType,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isEmpty 
                              ? AppTextColors.secondary 
                              : AppTextColors.primary,
                        ),
                      ),
                    ),
                    if (!isEmpty)
                      Text(
                        '$calories kcal',
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTextColors.primary,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  isEmpty ? 'Tap to add meal' : '$time  $items',
                  style: AppTypography.bodySmall.copyWith(
                    color: isEmpty 
                        ? AppTextColors.tertiary 
                        : AppTextColors.secondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          if (!isEmpty) ...[
            SizedBox(width: AppSpacing.space8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: AppTextColors.tertiary,
            ),
          ],
        ],
      ),
    );
  }
}
