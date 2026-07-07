import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_detail/workout_hero_card.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_detail/workout_stats_row.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_detail/exercise_list.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_player/workout_player_page.dart';

class WorkoutDetailPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailPage({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColorPalette.pureWhite,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColorPalette.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColorPalette.absoluteBlack.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColorPalette.gray900,
                  size: 18.sp,
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColorPalette.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColorPalette.absoluteBlack.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: AppColorPalette.gray900,
                    size: 20.sp,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: WorkoutHeroCard(workout: workout),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Description
                  Text(
                    workout.title,
                    style: AppTypography.headlineLarge,
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  Text(
                    workout.description,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space24.h),

                  // Stats Row
                  WorkoutStatsRow(
                    duration: workout.duration,
                    calories: workout.calories,
                    exercises: workout.exercises.length,
                    level: workout.level,
                  ),
                  SizedBox(height: AppSpacing.space32.h),

                  // Exercises Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercises',
                        style: AppTypography.headlineSmall,
                      ),
                      Text(
                        '${workout.exercises.length} exercises',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppTextColor.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.space16.h),

                  // Exercise List
                  ExerciseList(exercises: workout.exercises),
                  SizedBox(height: AppSpacing.space32.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSpacing.screenPadding.w),
        decoration: BoxDecoration(
          color: AppColorPalette.pureWhite,
          border: Border(
            top: BorderSide(color: AppColorPalette.gray200),
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => WorkoutPlayerPage(workout: workout),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColorPalette.gray900, AppColorPalette.gray800],
                ),
                borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColorPalette.gray900.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: AppColorPalette.pureWhite,
                    size: 28.sp,
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Text(
                    'START WORKOUT',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColorPalette.pureWhite,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
