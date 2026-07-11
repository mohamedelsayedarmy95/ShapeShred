import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/pages/body_metrics_page.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/services/preferences_service.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  String? _selectedGoal;

  final List<Map<String, dynamic>> _goals = [
    {
      'id': 'lose_weight',
      'title': 'Lose Weight',
      'subtitle': 'Burn fat and get lean',
      'icon': Icons.trending_down,
    },
    {
      'id': 'build_muscle',
      'title': 'Build Muscle',
      'subtitle': 'Gain strength and size',
      'icon': Icons.fitness_center,
    },
    {
      'id': 'maintain',
      'title': 'Stay Fit',
      'subtitle': 'Maintain current physique',
      'icon': Icons.favorite,
    },
    {
      'id': 'improve_endurance',
      'title': 'Improve Endurance',
      'subtitle': 'Boost stamina and cardio',
      'icon': Icons.directions_run,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _FadeSlideIn(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'What\'s your goal?',
                  style: AppTypography.headlineLarge,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  'We\'ll personalize your experience',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space32.h),

                // Goal Options
                Expanded(
                  child: ListView.separated(
                    itemCount: _goals.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSpacing.space12.h),
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> goal = _goals[index];
                      final isSelected = _selectedGoal == goal['id'];

                      return _StaggeredEntry(
                        index: index,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGoal = goal['id'] as String?;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.space20.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.radiusLarge),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.outline,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.onPrimary
                                            .withValues(alpha: 0.2)
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.radiusMedium),
                                  ),
                                  child: Icon(
                                    goal['icon'] as IconData,
                                    color: isSelected
                                        ? AppColors.onPrimary
                                        : AppTextColors.primary,
                                    size: 28.sp,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.space16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        goal['title'] as String,
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          color: isSelected
                                              ? AppColors.onPrimary
                                              : AppTextColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.space4.h),
                                      Text(
                                        goal['subtitle'] as String,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isSelected
                                              ? AppColors.onPrimary
                                                  .withValues(alpha: 0.75)
                                              : AppTextColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.onPrimary,
                                    size: 24.sp,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Continue Button
                GestureDetector(
                  onTap: _selectedGoal != null
                      ? () async {
                          await PreferencesService.setUserGoal(_selectedGoal!);
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BodyMetricsPage(),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      color: _selectedGoal != null
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusLarge),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CONTINUE',
                          style: AppTypography.labelLarge.copyWith(
                            color: _selectedGoal != null
                                ? AppColors.onPrimary
                                : AppTextColors.tertiary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: AppSpacing.space8.w),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedGoal != null
                              ? AppColors.onPrimary
                              : AppTextColors.tertiary,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fades and slides its child up once, on first build.
class _FadeSlideIn extends StatelessWidget {
  final Widget child;

  const _FadeSlideIn({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.cinematic,
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Fades and slides its child up with an index-based stagger delay.
class _StaggeredEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredEntry({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.standard +
          Duration(milliseconds: index * AnimationStaggerConfig.delay),
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
