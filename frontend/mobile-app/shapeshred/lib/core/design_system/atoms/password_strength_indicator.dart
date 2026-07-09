import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

/// Ultra Premium Password Strength Indicator
/// Visual feedback for password strength with animated progress
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final double? width;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.width,
  });

  PasswordStrength _calculateStrength() {
    if (password.isEmpty) return PasswordStrength.empty;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Complexity checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();
    
    if (strength == PasswordStrength.empty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStrengthBar(strength),
            ),
            SizedBox(width: AppSpacing.space8.w),
            Text(
              _getStrengthLabel(strength),
              style: AppTypography.labelSmall.copyWith(
                color: _getStrengthColor(strength),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space4.h),
        Text(
          _getStrengthHint(strength),
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColor.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthBar(PasswordStrength strength) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusTiny),
      child: LinearProgressIndicator(
        value: _getStrengthValue(strength),
        backgroundColor: AppColorPalette.gray200,
        valueColor: AlwaysStoppedAnimation<Color>(
          _getStrengthColor(strength),
        ),
        minHeight: 4.h,
      ),
    );
  }

  double _getStrengthValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
      case PasswordStrength.empty:
        return 0.0;
    }
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColorPalette.error;
      case PasswordStrength.medium:
        return AppColorPalette.warning;
      case PasswordStrength.strong:
        return AppColorPalette.success;
      case PasswordStrength.empty:
        return AppColorPalette.gray200;
    }
  }

  String _getStrengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.empty:
        return '';
    }
  }

  String _getStrengthHint(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Add uppercase, numbers, or special characters';
      case PasswordStrength.medium:
        return 'Almost there! Add more complexity';
      case PasswordStrength.strong:
        return 'Perfect! Your password is strong';
      case PasswordStrength.empty:
        return '';
    }
  }
}

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}


