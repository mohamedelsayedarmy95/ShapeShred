import 'package:flutter/material.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isError;

  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(
            color: AppSemanticColors.primary
                .withValues(alpha: AppOpacity.inactive)),
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
              color:
                  isError ? AppSemanticColors.error : AppSemanticColors.primary,
              width: 2),
        ),
      ),
    );
  }
}
