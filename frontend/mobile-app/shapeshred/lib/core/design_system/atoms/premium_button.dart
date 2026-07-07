import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

enum ButtonVariant { primary, secondary, outline, ghost }
enum ButtonSize { small, medium, large }

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 40.h;
      case ButtonSize.medium:
        return 48.h;
      case ButtonSize.large:
        return 56.h;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.labelMedium;
      case ButtonSize.medium:
        return AppTypography.labelLarge;
      case ButtonSize.large:
        return AppTypography.titleMedium;
    }
  }

  Color get _backgroundColor {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColorPalette.absoluteBlack;
      case ButtonVariant.secondary:
        return AppColorPalette.gray100;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColorPalette.pureWhite;
      case ButtonVariant.secondary:
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return AppColorPalette.absoluteBlack;
    }
  }

  Border? get _border {
    if (variant == ButtonVariant.outline) {
      return Border.all(
        color: AppColorPalette.absoluteBlack,
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
            side: _border?.left.color != null 
                ? BorderSide(color: _border!.left.color!, width: 1.5)
                : BorderSide.none,
          ),
          textStyle: _textStyle.copyWith(color: _foregroundColor),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20.sp),
                    SizedBox(width: 8.w),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
