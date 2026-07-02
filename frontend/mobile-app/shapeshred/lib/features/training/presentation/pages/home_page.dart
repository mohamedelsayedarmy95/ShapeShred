import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/app_button.dart';
import 'package:shapeshred/core/design_system/atoms/press_feedback.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.w,
            vertical: AppSpacing.space16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: AppSpacing.space32.h),
              _buildHeroCard(context),
              SizedBox(height: AppSpacing.space32.h),
              _buildStatsRow(),
              SizedBox(height: AppSpacing.space40.h),
              _buildSectionTitle('Recommended'),
              SizedBox(height: AppSpacing.space16.h),
              _buildRecommendationsCarousel(),
              SizedBox(height: AppSpacing.space32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            Text(
              'Ahmed 👋',
              style: AppTypography.textTheme.headlineMedium,
            ),
          ],
        ),
        PressFeedback(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppSurfaceLevel.elevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppColorPalette.gray200),
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              color: AppColorPalette.gray900,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        color: AppColorPalette.gray900,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 TODAY\'S WORKOUT',
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: AppColorPalette.gray400,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.space12.h),
          Text(
            'HIIT Cardio Blast',
            style: AppTypography.textTheme.headlineSmall?.copyWith(
              color: AppColorPalette.pureWhite,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            '20 min • High Intensity',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColorPalette.gray400,
            ),
          ),
          SizedBox(height: AppSpacing.space24.h),
          AppButton(
            text: 'START NOW',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go('/workout-player'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('🔥', '450', 'Calories'),
        SizedBox(width: AppSpacing.space12.w),
        _buildStatItem('⏱️', '32', 'Min'),
        SizedBox(width: AppSpacing.space12.w),
        _buildStatItem('💪', '4', 'Exercises'),
      ],
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.space16.h),
        decoration: BoxDecoration(
          color: AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColorPalette.gray200),
        ),
        child: Column(
          children: [
            Text(icon, style: TextStyle(fontSize: 24.sp)),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              value,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: AppTypography.textTheme.labelSmall?.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.textTheme.headlineSmall,
    );
  }

  Widget _buildRecommendationsCarousel() {
    return SizedBox(
      height: 180.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: const [
          WorkoutCard(
              title: 'Strength', duration: '30 min', level: 'Intermediate'),
          SizedBox(width: 16),
          WorkoutCard(title: 'Yoga', duration: '20 min', level: 'Beginner'),
          SizedBox(width: 16),
          WorkoutCard(title: 'Pilates', duration: '25 min', level: 'Advanced'),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 84.h,
      decoration: BoxDecoration(
        color: AppSurfaceLevel.background,
        border: Border(top: BorderSide(color: AppColorPalette.gray200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Home', true, '/home'),
          _buildNavItem(
              context, Icons.fitness_center_outlined, 'Training', false, '/training'),
          _buildNavItem(
              context, Icons.restaurant_outlined, 'Nutrition', false, '/nutrition'),
          _buildNavItem(context, Icons.person_outline, 'Profile', false, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      bool isActive, String route) {
    return PressFeedback(
      onTap: isActive ? null : () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColorPalette.gray900 : AppTextColor.tertiary,
            size: 28.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: isActive ? AppColorPalette.gray900 : AppTextColor.tertiary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
