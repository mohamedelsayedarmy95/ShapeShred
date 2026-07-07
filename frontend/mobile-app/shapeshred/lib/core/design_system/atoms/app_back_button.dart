import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/atoms/press_feedback.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PressFeedback(
      onTap: () {
        HapticHelper.light();
        if (onPressed != null) {
          onPressed!();
          return;
        }

        // Try Navigator first for standard push/pop
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        // Fallback to GoRouter
        else if (context.canPop()) {
          context.pop();
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppSurfaceLevel.elevated,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColorPalette.gray200,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: color ?? AppTextColor.primary,
          size: 18.sp,
        ),
      ),
    );
  }
}
