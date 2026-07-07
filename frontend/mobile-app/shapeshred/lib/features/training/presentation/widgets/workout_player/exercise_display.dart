import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';

class ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;
  final bool isResting;

  const ExerciseDisplay({
    super.key,
    required this.exercise,
    required this.isResting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Exercise Icon
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isResting
                  ? [AppColorPalette.gray500, AppColorPalette.gray400]
                  : [AppColorPalette.gray900, AppColorPalette.gray800],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isResting ? AppColorPalette.gray500 : AppColorPalette.gray900)
                    .withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Icon(
            isResting ? Icons.pause_circle_filled : exercise.icon,
            color: AppColorPalette.pureWhite,
            size: 60.sp,
          ),
        ),
        SizedBox(height: AppSpacing.space32.h),

        // Exercise Name
        Text(
          isResting ? 'REST' : exercise.name,
          style: AppTypography.headlineLarge.copyWith(
            color: isResting ? AppColorPalette.gray500 : AppColorPalette.gray900,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.space8.h),

        // Description
        Text(
          isResting ? 'Take a breather' : exercise.description,
          style: AppTypography.bodyLarge.copyWith(
            color: AppTextColor.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
