import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/atoms/app_button.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLastPage = _currentPage == 2;

    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage(
                    context: context,
                    title: l10n.onboardingTitle1,
                    description: l10n.onboardingDesc1,
                    icon: Icons.fitness_center,
                  ),
                  _buildPage(
                    context: context,
                    title: l10n.onboardingTitle2,
                    description: l10n.onboardingDesc2,
                    icon: Icons.auto_awesome,
                  ),
                  _buildPage(
                    context: context,
                    title: l10n.onboardingTitle3,
                    description: l10n.onboardingDesc3,
                    icon: Icons.video_call,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
                vertical: AppSpacing.sectionSpacing.h,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const WormEffect(
                      dotColor: AppColorPalette.gray200,
                      activeDotColor: AppColorPalette.gray900,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space32.h),
                  Row(
                    children: [
                      if (!isLastPage)
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            l10n.skip,
                            style: AppTypography.textTheme.labelLarge?.copyWith(
                              color: AppTextColor.secondary,
                            ),
                          ),
                        ),
                      const Spacer(),
                      SizedBox(
                        width: isLastPage ? 160.w : 120.w,
                        child: AppButton(
                          text: isLastPage
                              ? l10n.getStarted
                              : l10n.continueAction,
                          onPressed: () {
                            if (isLastPage) {
                              context.go('/login');
                            } else {
                              _pageController.nextPage(
                                duration: AppDurations.long,
                                curve: AppCurves.easeStandard,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: const BoxDecoration(
              color: AppSurfaceLevel.elevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 56.sp,
              color: AppColorPalette.gray900,
            ),
          ),
          SizedBox(height: AppSpacing.space48.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.textTheme.displaySmall,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
