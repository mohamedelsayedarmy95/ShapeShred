import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class WorkoutProgressIndicator extends StatelessWidget {
  final int currentExercise;
  final int totalExercises;

  const WorkoutProgressIndicator({
    super.key,
    required this.currentExercise,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      child: Row(
        children: List.generate(
          totalExercises,
          (index) => Expanded(
            child: Container(
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: index < currentExercise
                    ? AppColorPalette.gray900
                    : AppColorPalette.gray200,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
