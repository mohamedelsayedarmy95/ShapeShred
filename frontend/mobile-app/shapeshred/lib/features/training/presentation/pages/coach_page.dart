import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';

class CoachPage extends StatelessWidget {
  const CoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_outlined,
                size: 80,
                color: AppTextColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Coach Dashboard',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Here you will connect with your coach.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
