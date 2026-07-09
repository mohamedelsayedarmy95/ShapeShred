import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/features/training/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentSlideIndex = 0;
  int _currentStep = 0; // 0: slides, 1: goal, 2: fitnessLevel, 3: completion
  String? _selectedGoal;
  String? _selectedFitnessLevel;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      icon: Icons.fitness_center,
      title: 'Transform Your Body',
      subtitle: 'AI-powered workouts that adapt to your progress and keep you challenged',
      highlight: 'Personalized',
    ),
    OnboardingSlideData(
      icon: Icons.restaurant,
      title: 'Fuel Your Goals',
      subtitle: 'Smart nutrition plans that evolve with your tastes and objectives',
      highlight: 'Smart Nutrition',
    ),
    OnboardingSlideData(
      icon: Icons.trending_up,
      title: 'Track Your Triumphs',
      subtitle: 'See your progress in real-time and celebrate every milestone',
      highlight: 'Real-time Insights',
    ),
  ];

  final List<GoalOption> _goalOptions = [
    GoalOption('Lose Weight', Icons.fitness_center, 'Burn fat and achieve your ideal physique'),
    GoalOption('Build Muscle', Icons.fitness_center, 'Gain strength and lean muscle mass'),
    GoalOption('Endurance', Icons.directions_run, 'Improve stamina and cardiovascular health'),
    GoalOption('Stay Fit', Icons.access_time, 'Maintain a healthy, active lifestyle'),
  ];

  final List<FitnessLevelOption> _fitnessLevelOptions = [
    FitnessLevelOption('Beginner', Icons.emoji_people, 'Just starting your fitness journey'),
    FitnessLevelOption('Intermediate', Icons.people, 'Some experience, looking to level up'),
    FitnessLevelOption('Advanced', Icons.star, 'Experienced athlete seeking peak performance'),
  ];

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final completed = await PreferencesService.isOnboardingComplete();
    if (completed && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_currentSlideIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _goToStep(1); // Move to goal selection
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    if (step == 1) {
      // Reset page controller for slides if needed
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _selectGoal(String goal) {
    setState(() {
      _selectedGoal = goal;
    });
    _goToStep(2); // Move to fitness level
  }

  void _selectFitnessLevel(String level) {
    setState(() {
      _selectedFitnessLevel = level;
    });
    _goToStep(3); // Move to completion
  }

  Future<void> _completeOnboarding() async {
    await PreferencesService.setUserGoal(_selectedGoal ?? '');
    await PreferencesService.setFitnessLevel(_selectedFitnessLevel ?? '');
    await PreferencesService.setOnboardingComplete(true);

    // Create user profile in Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'goal': _selectedGoal,
          'fitnessLevel': _selectedFitnessLevel,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      // Firestore error shouldn't block onboarding completion
      debugPrint('Error creating user profile: $e');
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (only on slides step)
            if (_currentStep == 0)
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

            // Page Content
            Expanded(
              child: _buildStepContent(),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: _buildBottomSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return PageView.builder(
          controller: _pageController,
          itemCount: _slides.length,
          onPageChanged: (index) {
            setState(() {
              _currentSlideIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return OnboardingSlide(slide: _slides[index]);
          },
        );
      case 1:
        return _buildGoalSelection();
      case 2:
        return _buildFitnessLevelSelection();
      case 3:
        return _buildCompletion();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGoalSelection() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 80.sp, color: AppColorPalette.gray900),
          SizedBox(height: AppSpacing.space32.h),
          Text(
            'What is your main goal?',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'Choose one to get started',
            style: AppTypography.bodyLarge.copyWith(
              color: AppTextColor.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space32.h),
          Wrap(
            spacing: AppSpacing.space12.w,
            runSpacing: AppSpacing.space12.h,
            children: _goalOptions.map((option) => _buildGoalOption(option)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption(GoalOption option) {
    final bool isSelected = _selectedGoal == option.title;
    return GestureDetector(
      onTap: () => _selectGoal(option.title),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray50,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
              border: Border.all(
                color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              option.icon,
              size: 28.sp,
              color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            option.title,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            option.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColor.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessLevelSelection() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_people, size: 80.sp, color: AppColorPalette.gray900),
          SizedBox(height: AppSpacing.space32.h),
          Text(
            'What is your current fitness level?',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'This helps us tailor your workouts',
            style: AppTypography.bodyLarge.copyWith(
              color: AppTextColor.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space32.h),
          Wrap(
            spacing: AppSpacing.space12.w,
            runSpacing: AppSpacing.space12.h,
            children: _fitnessLevelOptions.map((option) => _buildFitnessLevelOption(option)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessLevelOption(FitnessLevelOption option) {
    final bool isSelected = _selectedFitnessLevel == option.title;
    return GestureDetector(
      onTap: () => _selectFitnessLevel(option.title),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray50,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
              border: Border.all(
                color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              option.icon,
              size: 28.sp,
              color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            option.title,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            option.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColor.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80.sp, color: AppColorPalette.success),
          SizedBox(height: AppSpacing.space24.h),
          Text(
            'Almost there!',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'Let\'s finish setting up your profile',
            style: AppTypography.bodyLarge.copyWith(
              color: AppTextColor.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space32.h),
          // Permission explanation
          Column(
            children: [
              _buildPermissionItem(
                Icons.notifications_active,
                'Notifications',
                'Get workout reminders and progress updates',
              ),
              _buildPermissionItem(
                Icons.fitness_center,
                'Health Data',
                'Sync with Apple Health/Google Fit for accurate tracking',
              ),
              _buildPermissionItem(
                Icons.location_on,
                'Location',
                'Track outdoor workouts and provide location-based recommendations',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space32.h),
          // Get Started Button
          GestureDetector(
            onTap: _completeOnboarding,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h),
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
                  Text(
                    'GET STARTED',
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
        ],
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColorPalette.gray600),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColorPalette.gray900,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    switch (_currentStep) {
      case 0:
        return _buildSlidesBottomSection();
      case 1:
        return _buildGoalBottomSection();
      case 2:
        return _buildFitnessLevelBottomSection();
      case 3:
        return _buildCompletionBottomSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSlidesBottomSection() {
    return Column(
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
          onTap: _nextSlide,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.h),
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
                Text(
                  _currentSlideIndex == _slides.length - 1
                      -> 'CONTINUE'
                      : 'NEXT',
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
      ],
    );
  }

  Widget _buildGoalBottomSection() {
    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => _goToStep(0), // Back to slides
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColorPalette.gray600,
              ),
            ),
          ),
        ),
        Spacer(),
        SizedBox(height: AppSpacing.space16.h),
      ],
    );
  }

  Widget _buildFitnessLevelBottomSection() {
    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => _goToStep(1), // Back to goal selection
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColorPalette.gray600,
              ),
            ),
          ),
        ),
        Spacer(),
        SizedBox(height: AppSpacing.space16.h),
      ],
    );
  }

  Widget _buildCompletionBottomSection() {
    return Column(
      children: [
        // No back button on completion step
        Spacer(),
        SizedBox(height: AppSpacing.space16.h),
      ],
    );
  }
}

class OnboardingSlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String highlight;

  const OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.highlight,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData slide;

  const OnboardingSlide({
    super.key,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColorPalette.gray900, AppColorPalette.gray700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColorPalette.gray900.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              slide.icon,
              color: AppColorPalette.pureWhite,
              size: 80.sp,
            ),
          ),
          SizedBox(height: AppSpacing.space48.h),

          // Highlight Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: AppColorPalette.gray100,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
            ),
            child: Text(
              slide.highlight.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColorPalette.gray700,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space24.h),

          // Title
          Text(
            slide.title,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space16.h),

          // Subtitle
          Text(
            slide.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppTextColor.secondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GoalOption {
  final String title;
  final IconData icon;
  final String subtitle;

  const GoalOption(this.title, this.icon, this.subtitle);
}

class FitnessLevelOption {
  final String title;
  final IconData icon;
  final String subtitle;

  const FitnessLevelOption(this.title, this.icon, this.subtitle);
}