import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class CoachCard extends StatelessWidget {
  final String coachName;
  final String specialty;
  final double rating;
  final bool isOnline;

  const CoachCard({
    super.key,
    required this.coachName,
    required this.specialty,
    required this.rating,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.heroGradient,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      coachName.isNotEmpty ? coachName[0].toUpperCase() : 'C',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 2.w,
                    bottom: 2.h,
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: AppSpacing.space16.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          coachName,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.space2.h),
                  Text(
                    specialty,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppTextColors.primary,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$rating',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppSpacing.space12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppRadius.radiusPill),
                        ),
                        child: Text(
                          isOnline ? 'Online' : 'Offline',
                          style: AppTypography.labelSmall.copyWith(
                            color: isOnline
                                ? AppColors.success
                                : AppTextColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Message Button
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outline),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppTextColors.primary,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
