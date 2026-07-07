import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.space16.h,
          horizontal: AppSpacing.space8.w,
        ),
        decoration: BoxDecoration(
          color: AppColorPalette.gray50,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: AppColorPalette.gray200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 24.sp)),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              value,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.space2.h),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppTextColor.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
