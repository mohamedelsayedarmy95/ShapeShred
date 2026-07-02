import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppInput({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.textTheme.labelMedium?.copyWith(
            color: AppTextColor.secondary,
          ),
        ),
        const SizedBox(height: AppSpacing.elementSpacing),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppSurfaceLevel.elevated,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.contentPadding,
              vertical: AppSpacing.contentPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
              borderSide: const BorderSide(color: AppColorPalette.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
              borderSide: const BorderSide(color: AppColorPalette.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
              borderSide:
                  const BorderSide(color: AppColorPalette.gray900, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
              borderSide: const BorderSide(color: AppColorPalette.gray800),
            ),
          ),
        ),
      ],
    );
  }
}
