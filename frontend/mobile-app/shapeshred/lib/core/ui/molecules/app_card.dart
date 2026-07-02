import 'package:flutter/material.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppSemanticColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        boxShadow: AppElevation.medium,
      ),
      padding: const EdgeInsets.all(AppSpacing.m),
      child: child,
    );
  }
}
