import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/shadows.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool hasBorder;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(AppSpacing.cardPadding.w),
        decoration: BoxDecoration(
          color: AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          border: hasBorder
              ? Border.all(color: AppColorPalette.gray200, width: 1)
              : null,
          boxShadow: AppShadows.subtle,
        ),
        child: child,
      ),
    );
  }
}
