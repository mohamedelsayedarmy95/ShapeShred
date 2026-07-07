import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class PremiumCard extends StatelessWidget {
  final bool isPremium;
  final VoidCallback? onUpgrade;

  const PremiumCard({
    super.key,
    required this.isPremium,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return _buildPremiumActive();
    }
    return _buildUpgradeCard();
  }

  Widget _buildUpgradeCard() {
    return GestureDetector(
      onTap: onUpgrade,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.space20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColorPalette.absoluteBlack, AppColorPalette.gray800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          boxShadow: [
            BoxShadow(
              color: AppColorPalette.absoluteBlack.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: AppColorPalette.pureWhite,
                        size: 24.sp,
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Text(
                        'GO PREMIUM',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColorPalette.pureWhite,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.space12.h),
                  Text(
                    'Unlock AI coaching, advanced analytics, and personalized plans',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColorPalette.gray300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: AppColorPalette.pureWhite,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Upgrade',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColorPalette.absoluteBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumActive() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColorPalette.gray900, AppColorPalette.gray700],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: AppColorPalette.pureWhite,
            size: 32.sp,
          ),
          SizedBox(width: AppSpacing.space16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Active',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Renews on Dec 15, 2026',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColorPalette.gray300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
