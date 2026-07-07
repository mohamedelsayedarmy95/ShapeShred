import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/shadows.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

/// Ultra Premium Button with haptic feedback and premium animations
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final bool isDestructive;
  final IconData? icon;
  final Widget? trailing;
  final bool fullWidth;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.isDestructive = false,
    this.icon,
    this.trailing,
    this.fullWidth = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.short,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.premiumEase),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.premiumEase),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticHelper.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  Color get _backgroundColor {
    if (widget.isDestructive) return AppColorPalette.error;
    if (widget.isSecondary) return AppColorPalette.gray100;
    return AppColorPalette.absoluteBlack;
  }

  Color get _foregroundColor {
    if (widget.isDestructive) return AppColorPalette.pureWhite;
    if (widget.isSecondary) return AppColorPalette.gray900;
    return AppColorPalette.pureWhite;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: isEnabled
              ? () {
                  HapticHelper.mediumImpact();
                  widget.onPressed!();
                }
              : null,
          child: AnimatedScale(
            scale: _scaleAnimation.value,
            duration: AppDurations.short,
            curve: AppCurves.premiumEase,
            child: AnimatedOpacity(
              opacity: _opacityAnimation.value,
              duration: AppDurations.short,
              curve: AppCurves.premiumEase,
              child: Container(
                width: widget.fullWidth ? double.infinity : null,
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled ? _backgroundColor : AppColorPalette.gray200,
                  borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                  boxShadow: isEnabled
                      ? [
                          AppShadows.buttonShadow,
                        ]
                      : null,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _foregroundColor,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                size: 20,
                                color: _foregroundColor,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _foregroundColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (widget.trailing != null) ...[
                              const SizedBox(width: 12),
                              widget.trailing!,
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
