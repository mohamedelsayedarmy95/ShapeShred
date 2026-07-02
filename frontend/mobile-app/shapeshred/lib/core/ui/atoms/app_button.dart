import 'package:flutter/material.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

enum ButtonType { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: type == ButtonType.primary
            ? AppSemanticColors.primary
            : (type == ButtonType.secondary
                ? AppSemanticColors.surface
                : Colors.transparent),
        foregroundColor: type == ButtonType.primary
            ? theme.colorScheme.onPrimary
            : AppSemanticColors.primary,
        elevation: type == ButtonType.ghost ? 0 : 2,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m, vertical: AppSpacing.s),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          side: type == ButtonType.secondary
              ? const BorderSide(color: AppSemanticColors.primary)
              : BorderSide.none,
        ),
      ),
      child: Text(text,
          style: AppTypography.label.copyWith(
              fontSize: 16,
              color: type == ButtonType.primary
                  ? theme.colorScheme.onPrimary
                  : AppSemanticColors.primary)),
    );
  }
}
