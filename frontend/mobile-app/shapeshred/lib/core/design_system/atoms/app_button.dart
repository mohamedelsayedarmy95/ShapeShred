import 'package:flutter/material.dart';
import '../../utils/helpers/haptic_helper.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/typography.dart';
import 'press_feedback.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PressFeedback(
      onTap: isLoading
          ? null
          : () {
              HapticHelper.light();
              onPressed?.call();
            },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: _getDecoration(),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColorPalette.pureWhite),
                ),
              )
            : Text(
                text,
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: _getTextColor(),
                ),
              ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          color: AppColorPalette.gray900,
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: AppColorPalette.gray200,
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColorPalette.gray300, width: 1.5),
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        );
    }
  }

  Color _getTextColor() {
    if (variant == AppButtonVariant.primary) return AppColorPalette.pureWhite;
    return AppTextColor.primary;
  }
}
