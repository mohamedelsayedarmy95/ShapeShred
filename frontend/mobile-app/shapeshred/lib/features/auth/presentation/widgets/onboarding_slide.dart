import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class OnboardingSlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String highlight;

  OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.highlight,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData slide;

  const OnboardingSlide({
    super.key,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColorPalette.gray900, AppColorPalette.gray700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColorPalette.gray900.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              slide.icon,
              color: AppColorPalette.pureWhite,
              size: 80.sp,
            ),
          ),
          SizedBox(height: AppSpacing.space48.h),

          // Highlight Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: AppColorPalette.gray100,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              slide.highlight.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColorPalette.gray700,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space24.h),

          // Title
          Text(
            slide.title,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space16.h),

          // Subtitle
          Text(
            slide.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppTextColor.secondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
