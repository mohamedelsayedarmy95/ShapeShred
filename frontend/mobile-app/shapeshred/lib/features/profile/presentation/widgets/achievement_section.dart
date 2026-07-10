import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class AchievementSection extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementSection({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: AppTypography.headlineSmall,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: AppTypography.labelLarge.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space16.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (context, index) => SizedBox(width: AppSpacing.space12.w),
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _AchievementBadge(
                title: achievement['title'] as String,
                icon: achievement['icon'] as String,
                unlocked: achievement['unlocked'] as bool,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String title;
  final String icon;
  final bool unlocked;

  const _AchievementBadge({
    required this.title,
    required this.icon,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(AppSpacing.space12.w),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.surfaceVariant : AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(
          color: unlocked ? AppColors.outline : AppColors.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: unlocked ? AppColors.surface : AppColors.outline,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: unlocked ? null : AppTextColors.tertiary,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: unlocked ? AppTextColors.primary : AppTextColors.tertiary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
