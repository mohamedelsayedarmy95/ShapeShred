import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

/// Ultra Premium Text Field with premium animations and validation
class PremiumTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? errorText;
  final bool showCharacterCount;
  final FocusNode? focusNode;

  const PremiumTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.errorText,
    this.showCharacterCount = false,
    this.focusNode,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = AnimationController(
      duration: AppDurations.short,
      vsync: this,
    );
    _borderAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.premiumEase),
    );
    _borderColorAnimation = ColorTween(
      begin: AppColorPalette.gray200,
      end: AppColorPalette.absoluteBlack,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.premiumEase),
    );

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    final isFocused = _focusNode.hasFocus;
    if (isFocused != _isFocused) {
      setState(() => _isFocused = isFocused);
      if (isFocused) {
        _controller.forward();
        HapticHelper.lightImpact();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final currentLength = widget.controller?.text.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: hasError ? AppColorPalette.error : AppColorPalette.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: widget.enabled
                    ? AppColorPalette.gray50
                    : AppColorPalette.gray100,
                borderRadius: BorderRadius.circular(AppRadius.m),
                border: Border.all(
                  color: hasError
                      ? AppColorPalette.error
                      : (_borderColorAnimation.value ?? AppColorPalette.gray200),
                  width: hasError ? 2 : _borderAnimation.value,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: AppTypography.bodyMedium.copyWith(
                  color: widget.enabled
                      ? AppColorPalette.gray900
                      : AppColorPalette.gray500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColorPalette.gray400,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppColorPalette.absoluteBlack
                              : AppColorPalette.gray400,
                          size: 20,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: _isFocused
                                ? AppColorPalette.absoluteBlack
                                : AppColorPalette.gray400,
                            size: 20,
                          ),
                          onPressed: widget.onSuffixIconPressed,
                        )
                      : null,
                  counterText: widget.showCharacterCount && widget.maxLength != null
                      ? '$currentLength/${widget.maxLength}'
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.inputPaddingHorizontal,
                    vertical: AppSpacing.inputPaddingVertical,
                  ),
                ),
              ),
            );
          },
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.space8),
          Text(
            widget.errorText!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColorPalette.error,
            ),
          ),
        ],
      ],
    );
  }
}
