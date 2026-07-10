import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';

/// Ultra Premium Empty State Widget
/// Elegant empty state with illustration, message, and action button
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget? customIllustration;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.customIllustration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or Icon
            if (customIllustration != null)
              SizedBox(
                width: 200.w,
                height: 200.h,
                child: customIllustration,
              )
            else
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48.sp,
                  color: AppTextColors.tertiary,
                ),
              ),
            SizedBox(height: AppSpacing.space24.h),

            // Title
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.space12.h),

            // Message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTextColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.space24.h),

            // Action Button
            if (actionLabel != null && onActionPressed != null)
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space24.w,
                    vertical: AppSpacing.space16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty State Variants
class EmptyStates {
  EmptyStates._();

  /// No workouts empty state
  static Widget noWorkouts({VoidCallback? onActionPressed}) {
    return EmptyState(
      icon: Icons.fitness_center_outlined,
      title: 'No workouts yet',
      message: 'Start your fitness journey by adding your first workout',
      actionLabel: 'Add Workout',
      onActionPressed: onActionPressed,
    );
  }

  /// No nutrition plans empty state
  static Widget noNutrition({VoidCallback? onActionPressed}) {
    return EmptyState(
      icon: Icons.restaurant_outlined,
      title: 'No nutrition plans',
      message: 'Create a meal plan to track your nutrition goals',
      actionLabel: 'Create Plan',
      onActionPressed: onActionPressed,
    );
  }

  /// No progress empty state
  static Widget noProgress({VoidCallback? onActionPressed}) {
    return EmptyState(
      icon: Icons.trending_up_outlined,
      title: 'No progress yet',
      message: 'Complete your first workout to start tracking progress',
      actionLabel: 'Start Workout',
      onActionPressed: onActionPressed,
    );
  }

  /// No notifications empty state
  static Widget noNotifications() {
    return const EmptyState(
      icon: Icons.notifications_outlined,
      title: 'No notifications',
      message: 'You\'re all caught up!',
    );
  }

  /// Search results empty state
  static Widget noResults({String? query, VoidCallback? onClear}) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No results found',
      message: query != null ? 'No results for "$query"' : 'Try a different search term',
      actionLabel: 'Clear Search',
      onActionPressed: onClear,
    );
  }

  /// Network error empty state
  static Widget networkError({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'Connection lost',
      message: 'Check your internet connection and try again',
      actionLabel: 'Retry',
      onActionPressed: onRetry,
    );
  }

  /// Generic error empty state
  static Widget error({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: 'An unexpected error occurred. Please try again.',
      actionLabel: 'Retry',
      onActionPressed: onRetry,
    );
  }
}
