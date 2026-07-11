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
import 'package:shapeshred/features/auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperUltraPremiumOnboardingPage extends StatefulWidget {
  const SuperUltraPremiumOnboardingPage({super.key});

  @override
  State<SuperUltraPremiumOnboardingPage> createState() => _SuperUltraPremiumOnboardingPageState();
}

class _SuperUltraPremiumOnboardingPageState extends State<SuperUltraPremiumOnboardingPage> with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  String? _selectedGoal;
  String? _selectedFitnessLevel;

  final List<OnboardingSlideData> _slides = [
    const OnboardingSlideData(
      icon: Icons.fitness_center,
      title: 'Transform Your Body',
      subtitle:
      'AI-powered workouts that adapt to your progress and keep you challenged',
      highlight: 'Personalized',
    ),
    const OnboardingSlideData(
      icon: Icons.restaurant,
      title: 'Fuel Your Goals',
      subtitle:
      'Smart nutrition plans that evolve with your tastes and objectives',
      highlight: 'Smart Nutrition',
    ),
    const OnboardingSlideData(
      icon: Icons.trending_up,
      title: 'Track Your Triumphs',
      subtitle: 'See your progress in real-time and celebrate every milestone',
      highlight: 'Real-time Insights',
    ),
  ];

  final List<GoalOption> _goalOptions = [
    const GoalOption('Lose Weight', Icons.fitness_center,
        'Burn fat and achieve your ideal physique'),
    const GoalOption('Build Muscle', Icons.fitness_center,
        'Gain strength and lean muscle mass'),
    const GoalOption('Endurance', Icons.directions_run,
        'Improve stamina and cardiovascular health'),
    const GoalOption(
        'Stay Fit', Icons.access_time, 'Maintain a healthy, active lifestyle'),
  ];

  final List<FitnessLevelOption> _fitnessLevelOptions = [
    const FitnessLevelOption(
        'Beginner', Icons.emoji_people, 'Just starting your fitness journey'),
    const FitnessLevelOption(
        'Intermediate', Icons.people, 'Some experience, looking to level up'),
    const FitnessLevelOption(
        'Advanced', Icons.star, 'Experienced athlete seeking peak performance'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: AppDurations.extravagant,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppCurves.premiumFluid,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppCurves.premiumSmooth,
      ),
    );

    _animationController.forward();
    _checkOnboardingStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
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

  void _nextPage() {
    if (_currentPageIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: AppDurations.substantial,
        curve: AppCurves.premiumFluid,
      );
    } else {
      _goToGoalSelection();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _goToGoalSelection() {
    setState(() {
      _currentPageIndex = _slides.length; // Index for goal selection step
    });
  }

  void _goToFitnessLevelSelection() {
    setState(() {
      _currentPageIndex = _slides.length + 1; // Index for fitness level step
    });
  }

  void _goToCompletion() {
    setState(() {
      _currentPageIndex = _slides.length + 2; // Index for completion step
    });
  }

  void _selectGoal(String goal) {
    setState(() {
      _selectedGoal = goal;
    });
    _goToFitnessLevelSelection();
  }

  void _selectFitnessLevel(String level) {
    setState(() {
      _selectedFitnessLevel = level;
    });
    _goToCompletion();
  }

  Future<void> _completeOnboarding() async {
    await PreferencesService.setUserGoal(_selectedGoal ?? '');
    await PreferencesService.setFitnessLevel(_selectedFitnessLevel ?? '');
    await PreferencesService.setOnboardingComplete(true);

    // Create user profile in Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
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
      // Check if user is logged in; if not, send to login screen
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, proceed to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // User is not logged in, send to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildPageContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentPageIndex) {
      case 0:
      case 1:
      case 2:
        return _buildOnboardingSlides();
      case 3:
        return _buildGoalSelection();
      case 4:
        return _buildFitnessLevelSelection();
      case 5:
        return _buildCompletion();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOnboardingSlides() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _slides.length,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return _FadeSlideIn(
          key: ValueKey(index),
          child: OnboardingSlide(slide: _slides[index]),
        );
      },
    );
  }

  Widget _buildGoalSelection() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 80.sp, color: AppColors.primary),
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
              color: AppTextColors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space32.h),
          Wrap(
            spacing: AppSpacing.space12.w,
            runSpacing: AppSpacing.space12.h,
            children: List.generate(
              _goalOptions.length,
              (index) => _StaggeredEntry(
                index: index,
                child: _buildGoalOption(_goalOptions[index]),
              ),
            ),
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
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              option.icon,
              size: 28.sp,
              color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            option.title,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppTextColors.secondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            option.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
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
          Icon(Icons.emoji_people, size: 80.sp, color: AppColors.primary),
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
              color: AppTextColors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.space32.h),
          Wrap(
            spacing: AppSpacing.space12.w,
            runSpacing: AppSpacing.space12.h,
            children: List.generate(
              _fitnessLevelOptions.length,
              (index) => _StaggeredEntry(
                index: index,
                child: _buildFitnessLevelOption(_fitnessLevelOptions[index]),
              ),
            ),
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
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              option.icon,
              size: 28.sp,
              color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            option.title,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppTextColors.secondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            option.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
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
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(Icons.check, size: 48.sp, color: AppColors.onPrimary),
          ),
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
              color: AppTextColors.secondary,
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
                  colors: AppColors.heroGradient,
                ),
                borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
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
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.onPrimary,
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
          Icon(icon, size: 20.sp, color: AppTextColors.secondary),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppTextColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidesBottomSection() {
    return Column(
      children: [
        // Page Indicator
        SmoothPageIndicator(
          controller: _pageController,
          count: _slides.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primary,
            dotColor: AppColors.outline,
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
                colors: AppColors.heroGradient,
              ),
              borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentPageIndex == _slides.length - 1
                      ? 'CONTINUE'
                      : 'NEXT',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: AppSpacing.space8.w),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.onPrimary,
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
            onTap: () => {
              setState(() {
                _currentPageIndex = 0; // Back to slides
              }),
              _pageController.animateToPage(
                0,
                duration: AppDurations.standard,
                curve: AppCurves.premiumFluid,
              )
            },
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppTextColors.secondary,
              ),
            ),
          ),
        ),
        const Spacer(),
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
            onTap: () => {
              setState(() {
                _currentPageIndex = _slides.length; // Back to goal selection
              }),
            },
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppTextColors.secondary,
              ),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(height: AppSpacing.space16.h),
      ],
    );
  }

  Widget _buildCompletionBottomSection() {
    return Column(
      children: [
        // No back button on completion step
        const Spacer(),
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
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              slide.icon,
              color: AppColors.onPrimary,
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
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.radiusPill),
            ),
            child: Text(
              slide.highlight.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppTextColors.secondary,
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
              color: AppTextColors.secondary,
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

/// Fades and slides its child up once, on first build.
class _FadeSlideIn extends StatelessWidget {
  final Widget child;

  const _FadeSlideIn({super.key, required this.child});

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