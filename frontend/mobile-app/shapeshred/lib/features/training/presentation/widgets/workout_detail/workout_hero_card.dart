import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';

class WorkoutHeroCard extends StatelessWidget {
  final Workout workout;

  const WorkoutHeroCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [workout.color, workout.color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -50.w,
            top: -50.h,
            child: Icon(
              workout.icon,
              size: 300.sp,
              color: AppColorPalette.pureWhite.withValues(alpha: 0.05),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding.w,
              100.h,
              AppSpacing.screenPadding.w,
              AppSpacing.space24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorPalette.pureWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    workout.category.toUpperCase(),
                    style: TextStyle(
                      color: AppColorPalette.pureWhite,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

