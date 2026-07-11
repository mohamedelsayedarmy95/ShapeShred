import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/auth/presentation/pages/login_page.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';

class FitnessLevelPage extends StatefulWidget {
  const FitnessLevelPage({super.key});

  @override
  State<FitnessLevelPage> createState() => _FitnessLevelPageState();
}

class _FitnessLevelPageState extends State<FitnessLevelPage> {
  String? _selectedLevel;

  final List<Map<String, dynamic>> _levels = [
    {
      'id': 'beginner',
      'title': 'Beginner',
      'subtitle': 'New to working out',
      'icon': Icons.emoji_people,
      'description': 'Just starting your fitness journey',
    },
    {
      'id': 'intermediate',
      'title': 'Intermediate',
      'subtitle': 'Some experience',
      'icon': Icons.directions_run,
      'description': 'Work out 2-3 times per week',
    },
    {
      'id': 'advanced',
      'title': 'Advanced',
      'subtitle': 'Regular athlete',
      'icon': Icons.fitness_center,
      'description': 'Work out 4+ times per week',
    },
    {
      'id': 'elite',
      'title': 'Elite',
      'subtitle': 'Professional level',
      'icon': Icons.emoji_events,
      'description': 'Competitive athlete or trainer',
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
                Text(
                  'Your fitness level',
                  style: AppTypography.headlineLarge,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  'We\'ll adjust the intensity accordingly',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space32.h),

                Expanded(
                  child: ListView.separated(
                    itemCount: _levels.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSpacing.space12.h),
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> level = _levels[index];
                      final isSelected = _selectedLevel == level['id'];

                      return _StaggeredEntry(
                        index: index,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLevel = level['id'] as String?;
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
                                    level['icon'] as IconData,
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
                                        level['title'] as String,
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
                                        level['description'] as String,
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
                  onTap: _selectedLevel != null
                      ? () async {
                          await PreferencesService.setFitnessLevel(
                              _selectedLevel!);
                          await PreferencesService.setOnboardingComplete(true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      color: _selectedLevel != null
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
                            color: _selectedLevel != null
                                ? AppColors.onPrimary
                                : AppTextColors.tertiary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: AppSpacing.space8.w),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedLevel != null
                              ? AppColors.onPrimary
                              : AppTextColors.tertiary,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
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
