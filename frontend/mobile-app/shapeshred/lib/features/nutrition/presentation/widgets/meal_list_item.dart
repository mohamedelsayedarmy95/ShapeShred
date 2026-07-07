import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

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
        color: isEmpty ? AppColorPalette.gray50 : AppColorPalette.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: isEmpty ? AppColorPalette.gray300 : AppColorPalette.gray200,
          style: isEmpty ? BorderStyle.solid : BorderStyle.solid,
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
                  ? AppColorPalette.gray200 
                  : AppColorPalette.gray100,
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            child: Icon(
              isEmpty ? Icons.add : icon,
              color: isEmpty 
                  ? AppColorPalette.gray500 
                  : AppColorPalette.gray700,
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
                              ? AppTextColor.secondary 
                              : AppTextColor.primary,
                        ),
                      ),
                    ),
                    if (!isEmpty)
                      Text(
                        '$calories kcal',
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColorPalette.gray900,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  isEmpty ? 'Tap to add meal' : '$time  $items',
                  style: AppTypography.bodySmall.copyWith(
                    color: isEmpty 
                        ? AppTextColor.tertiary 
                        : AppTextColor.secondary,
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
              color: AppColorPalette.gray400,
            ),
          ],
        ],
      ),
    );
  }
}
