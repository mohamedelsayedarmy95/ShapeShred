import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/molecules/stat_card.dart';
import 'package:shapeshred/core/design_system/molecules/workout_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.w,
            vertical: AppSpacing.space16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              SizedBox(height: AppSpacing.space32.h),
              
              // Hero Card - Today's Workout
              _buildHeroCard(),
              SizedBox(height: AppSpacing.space32.h),
              
              // Stats Row
              _buildStatsRow(),
              SizedBox(height: AppSpacing.space40.h),
              
              // Section Title
              Text(
                'Recommended',
                style: AppTypography.headlineSmall,
              ),
              SizedBox(height: AppSpacing.space16.h),
              
              // Recommendations Carousel
              _buildRecommendationsCarousel(),
              SizedBox(height: AppSpacing.space32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: AppTypography.bodyLarge.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              'Ahmed 👋',
              style: AppTypography.headlineMedium,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColorPalette.gray50,
            shape: BoxShape.circle,
            border: Border.all(color: AppColorPalette.gray200),
          ),
          child: Icon(
            Icons.notifications_none_outlined,
            color: AppColorPalette.gray900,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColorPalette.gray900, AppColorPalette.gray800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColorPalette.gray900.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: AppColorPalette.gray700,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '🔥 TODAY\'S WORKOUT',
              style: AppTypography.labelSmall.copyWith(
                color: AppColorPalette.pureWhite,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),
          Text(
            'HIIT Cardio Blast',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColorPalette.pureWhite,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppColorPalette.gray400,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '20 min',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColorPalette.gray400,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.bolt,
                color: AppColorPalette.gray400,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'High Intensity',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColorPalette.gray400,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space24.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColorPalette.pureWhite,
              borderRadius: BorderRadius.circular(AppRadius.l),
            ),
            child: Center(
              child: Text(
                'START WORKOUT',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColorPalette.gray900,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        const StatCard(icon: '🔥', value: '450', label: 'Calories'),
        SizedBox(width: AppSpacing.space12.w),
        const StatCard(icon: '⏱️', value: '32', label: 'Min'),
        SizedBox(width: AppSpacing.space12.w),
        const StatCard(icon: '💪', value: '4', label: 'Exercises'),
      ],
    );
  }

  Widget _buildRecommendationsCarousel() {
    return SizedBox(
      height: 200.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: const [
          WorkoutCard(
            title: 'Strength',
            duration: '30 min',
            level: 'Intermediate',
            icon: Icons.fitness_center,
          ),
          WorkoutCard(
            title: 'Yoga',
            duration: '20 min',
            level: 'Beginner',
            icon: Icons.self_improvement,
          ),
          WorkoutCard(
            title: 'Pilates',
            duration: '25 min',
            level: 'Advanced',
            icon: Icons.accessibility_new,
          ),
          WorkoutCard(
            title: 'HIIT',
            duration: '15 min',
            level: 'All Levels',
            icon: Icons.flash_on,
          ),
        ],
      ),
    );
  }
}
