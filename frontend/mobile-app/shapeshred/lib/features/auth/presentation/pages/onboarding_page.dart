import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/widgets/onboarding_slide.dart';
import 'package:shapeshred/features/auth/presentation/pages/goal_selection_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      icon: Icons.fitness_center,
      title: 'Train Smarter',
      subtitle: 'AI-powered workouts tailored to your goals and fitness level',
      highlight: 'Personalized',
    ),
    OnboardingSlideData(
      icon: Icons.restaurant,
      title: 'Eat Better',
      subtitle: 'Custom nutrition plans that adapt to your progress and preferences',
      highlight: 'Smart Nutrition',
    ),
    OnboardingSlideData(
      icon: Icons.trending_up,
      title: 'Track Progress',
      subtitle: 'Advanced analytics and insights to keep you motivated and on track',
      highlight: 'Real-time',
    ),
    OnboardingSlideData(
      icon: Icons.people,
      title: 'Expert Coaching',
      subtitle: 'Connect with certified coaches and get professional guidance',
      highlight: '24/7 Support',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GoalSelectionPage()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GoalSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  'Skip',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingSlide(slide: _slides[index]);
                },
              ),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColorPalette.absoluteBlack,
                      dotColor: AppColorPalette.gray300,
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      expansionFactor: 3,
                      spacing: 8.w,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space32.h),

                  // CTA Button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColorPalette.gray900, AppColorPalette.gray800],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.l),
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
                          Text(
                            _currentPage == _slides.length - 1
                                ? 'GET STARTED'
                                : 'CONTINUE',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColorPalette.pureWhite,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: AppSpacing.space8.w),
                          Icon(
                            Icons.arrow_forward,
                            color: AppColorPalette.pureWhite,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.space16.h),

                  // Social Proof
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColorPalette.gray900,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '4.9',
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Text(
                        '',
                        style: AppTypography.bodySmall,
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Text(
                        '2M+ Active Users',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppTextColor.secondary,
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
}
