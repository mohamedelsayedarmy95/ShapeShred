import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shapeshred/features/training/data/workout_history_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/atoms/skeleton_loader.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/profile/presentation/pages/body_composition_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/profile_photo_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/privacy_settings_page.dart';
import 'package:shapeshred/features/profile/presentation/widgets/profile_header.dart';
import 'package:shapeshred/features/profile/presentation/widgets/achievement_section.dart';
import 'package:shapeshred/features/profile/presentation/widgets/premium_status_card.dart';
import 'package:shapeshred/features/premium/presentation/pages/premium_page.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_history_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/analytics_detail_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/super_ultra_premium_analytics_detail_page.dart';
import 'package:shapeshred/features/auth/presentation/pages/super_ultra_premium_onboarding_page.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_player/super_ultra_premium_workout_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _fitnessLevel;
  String? _goal;
  double? _height;
  double? _weight;
  int? _age;
  String? _gender;
  String _motivationalMessage = '';
  bool _isLoading = true;
  bool _isPremiumUiEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
    try {
      // Load additional data from PreferencesService
      _fitnessLevel = await PreferencesService.getFitnessLevel();
      _goal = await PreferencesService.getUserGoal();
      _height = await PreferencesService.getUserHeight();
      _weight = await PreferencesService.getUserWeight();
      _age = await PreferencesService.getUserAge();
      _gender = await PreferencesService.getUserGender();

      // Set motivational message based on goal
      switch (_goal) {
        case 'Lose Weight':
          _motivationalMessage =
              'You are on a weight loss journey. Stay consistent!';
          break;
        case 'Build Muscle':
          _motivationalMessage =
              'You are building muscle. Keep pushing those weights!';
          break;
        case 'Endurance':
          _motivationalMessage =
              'You are building endurance. Every step counts!';
          break;
        case 'Stay Fit':
          _motivationalMessage =
              'You are maintaining a healthy lifestyle. Great job!';
          break;
        default:
          _motivationalMessage = 'Track your progress and reach your goals!';
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'Member';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Member since ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Please login first',
            style: AppTypography.bodyLarge,
          ),
        ),
      );
    }

    final displayName = user.displayName ?? user.email?.split('@')[0] ?? 'User';

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: AppTypography.headlineSmall.copyWith(
              color: AppTextColors.primary,
            ),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.w,
            vertical: AppSpacing.space16.h,
          ),
          child: Column(
            children: [
              SkeletonCard(height: 120.h),
              SizedBox(height: AppSpacing.space16.h),
              SkeletonCard(height: 90.h),
              SizedBox(height: AppSpacing.space16.h),
              SkeletonCard(height: 140.h),
              SizedBox(height: AppSpacing.space24.h),
              SkeletonLoader(width: 160.w, height: 22.h),
              SizedBox(height: AppSpacing.space16.h),
              const SkeletonList(itemCount: 4),
            ],
          ),
        ),
      );
    }

    final achievements = <Map<String, dynamic>>[
      {'title': 'Getting Started', 'icon': '🚀', 'unlocked': true},
      {'title': 'Goal Setter', 'icon': '🎯', 'unlocked': _goal != null},
      {'title': 'Assessed', 'icon': '💪', 'unlocked': _fitnessLevel != null},
      {
        'title': 'Profile Complete',
        'icon': '⭐',
        'unlocked': _goal != null &&
            _fitnessLevel != null &&
            _height != null &&
            _weight != null &&
            _age != null &&
            _gender != null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.headlineSmall.copyWith(
            color: AppTextColors.primary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.w,
          vertical: AppSpacing.space16.h,
        ),
        child: _FadeSlideIn(
          child: Column(
            children: [
              // Hero Header
              ProfileHeader(
                name: displayName,
                level: (_fitnessLevel ?? 'member').toUpperCase(),
                memberSince: _formatMemberSince(user.metadata.creationTime),
                avatarUrl: user.photoURL,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                _motivationalMessage,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Stats Grid
              Container(
                padding: EdgeInsets.all(AppSpacing.space16.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                        'Height',
                        _height != null
                            ? '${_height!.toStringAsFixed(0)} cm'
                            : '--'),
                    _buildStat(
                        'Weight',
                        _weight != null
                            ? '${_weight!.toStringAsFixed(1)} kg'
                            : '--'),
                    _buildStat('Age', _age != null ? '$_age years' : '--'),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Goal & Fitness Level
              Container(
                padding: EdgeInsets.all(AppSpacing.space16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  border: Border.all(color: AppColors.outline, width: 1),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Goal', _goal?.toUpperCase() ?? 'Not set'),
                    Divider(
                        color: AppColors.outline, height: AppSpacing.space8.h),
                    _buildInfoRow('Fitness Level',
                        _fitnessLevel?.toUpperCase() ?? 'Not set'),
                    Divider(
                        color: AppColors.outline, height: AppSpacing.space8.h),
                    _buildInfoRow(
                        'Gender', _gender?.toUpperCase() ?? 'Not set'),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Premium Upsell
              PremiumStatusCard(
                isPremium: false,
                onUpgrade: () {
                  HapticHelper.light();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PremiumPage()),
                  );
                },
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Achievements
              AchievementSection(achievements: achievements),
              SizedBox(height: AppSpacing.space24.h),

              // Analytics Card
              _buildAnalyticsCard(context),
              SizedBox(height: AppSpacing.space24.h),

              // Professional Features Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Professional Features',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space12.h),
              ..._buildStaggeredFeatureCards(context),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    if (mounted) context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding:
                        EdgeInsets.symmetric(vertical: AppSpacing.space16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusLarge),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'ShapeShred v1.0.0',
                style: AppTypography.bodySmall.copyWith(
                  color: AppTextColors.tertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                size: 24.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.space8.w),
              Text(
                'Training Analytics',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space12.h),
          FutureBuilder<Map<String, dynamic>>(
            future: _getAnalyticsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                final Color progressColor = AppColors.primary;
                return SizedBox(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Unable to load analytics data',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              return Column(
                children: [
                  _buildAnalyticsMetric(
                      'Progress Trend',
                      data['trend'] as String,
                      Icons.trending_up,
                      AppColors.success),
                  SizedBox(height: AppSpacing.space8.h),
                  _buildAnalyticsMetric('Workout Score', '${data['score']}%',
                      Icons.star, AppColors.warning),
                  SizedBox(height: AppSpacing.space8.h),
                  _buildAnalyticsMetric(
                      'Consistency',
                      '${data['consistency']}%',
                      Icons.reset_tv,
                      AppColors.info),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.space16.h),
          Center(
            child: TextButton(
              onPressed: () {
                HapticHelper.light();
                // Root-navigator route: full-screen, no bottom bar.
                context.push('/super-ultra-premium-analytics');
              },
              child: Text(
                'View Detailed Analytics',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Derived from the user's real workout history:
  /// - trend: this week's workout count vs last week's
  /// - score: this week's workouts against a 5/week target
  /// - consistency: active days as a share of days since the first workout
  ///   (capped at the last 28 days)
  Future<Map<String, dynamic>> _getAnalyticsData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'trend': 'no data', 'score': 0, 'consistency': 0};
    }

    final repo = FirebaseWorkoutHistoryRepository(
      firestore: FirebaseFirestore.instance,
      userId: user.uid,
    );
    final stats = await repo.getWorkoutStatistics();

    final int thisWeek = (stats['workoutsThisWeek'] as int?) ?? 0;
    final int lastWeek = (stats['workoutsLastWeek'] as int?) ?? 0;
    final int activeDays = (stats['activeDays'] as int?) ?? 0;
    final int totalWorkouts = (stats['totalWorkouts'] as int?) ?? 0;

    final String trend = totalWorkouts == 0
        ? 'no data'
        : thisWeek > lastWeek
            ? 'improving'
            : thisWeek < lastWeek
                ? 'declining'
                : 'steady';

    final int score = ((thisWeek / 5) * 100).clamp(0, 100).round();
    final int consistency =
        ((activeDays / 28) * 100).clamp(0, 100).round();

    return {'trend': trend, 'score': score, 'consistency': consistency};
  }

  Widget _buildAnalyticsMetric(
      String label, dynamic value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  value.toString(),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTextColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStaggeredFeatureCards(BuildContext context) {
    final cards = <Widget Function()>[
      () => _buildFeatureCard(
            icon: Icons.chat_bubble_outline,
            title: 'Chat with Coach',
            subtitle: 'Get personalized guidance',
            onTap: () {
              HapticHelper.light();
              _showCoachChatDialog();
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.accessibility_new,
            title: 'Body Composition',
            subtitle: 'Track your measurements',
            onTap: () {
              HapticHelper.light();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BodyCompositionPage()),
              );
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.photo_camera,
            title: 'Profile Photo',
            subtitle: 'Update your picture',
            onTap: () {
              HapticHelper.light();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfilePhotoPage()),
              );
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.history,
            title: 'Workout History',
            subtitle: 'View your past workouts',
            onTap: () {
              HapticHelper.light();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkoutHistoryPage()),
              );
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.restaurant_menu,
            title: 'Nutrition Tracking',
            subtitle: 'Log your meals',
            onTap: () {
              HapticHelper.light();
              context.go('/nutrition');
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.settings,
            title: 'Privacy Settings',
            subtitle: 'Manage your privacy',
            onTap: () {
              HapticHelper.light();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacySettingsPage()),
              );
            },
          ),
      () => _buildFeatureCard(
            icon: Icons.brush,
            title: 'UI Experience',
            subtitle: 'Toggle between Classic and Premium UI',
            onTap: () {
              HapticHelper.light();
              _showUiExperienceDialog(context);
            },
          ),
    ];

    return List.generate(cards.length, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.space8.h),
        child: _StaggeredEntry(
          index: index,
          child: cards[index](),
        ),
      );
    });
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.space4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
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
            Icon(
              Icons.chevron_right,
              color: AppTextColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showCoachChatDialog() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chat with Coach',
      barrierColor: AppColors.shadow,
      transitionDuration: AppDurations.cinematic,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: AppCurves.premiumBounce);
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: ScaleTransition(
            scale: curved,
            child: AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusXL),
              ),
              title: Column(
                children: [
                  Container(
                    width: 72.w,
                    height: 72.h,
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
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 34.sp,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  Text(
                    'Chat with Coach',
                    style: AppTypography.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This feature is coming soon!',
                    style: AppTypography.bodyMedium,
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  Text(
                    'You will be able to:',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  ...[
                    'Chat with certified fitness coaches',
                    'Get personalized workout plans',
                    'Receive nutrition advice',
                    'Track your progress with expert guidance',
                  ].map((item) => Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.space8.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16.sp,
                              color: AppColors.success,
                            ),
                            SizedBox(width: AppSpacing.space8.w),
                            Expanded(
                              child: Text(
                                item,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppTextColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticHelper.light();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusLarge),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showUiExperienceDialog(BuildContext context) async {
    final bool isPremiumUiEnabled = (await PreferencesService.getBool('premium_ui_enabled')) ?? false;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UI Experience',
      barrierColor: AppColors.shadow,
      transitionDuration: AppDurations.cinematic,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: AppCurves.premiumBounce);
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: ScaleTransition(
            scale: curved,
            child: AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusXL),
              ),
              title: Column(
                children: [
                  Container(
                    width: 72.w,
                    height: 72.h,
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
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.brush,
                      size: 34.sp,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  Text(
                    'UI Experience',
                    style: AppTypography.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose your preferred interface experience:',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.space24.h),
                  _buildUiOption(
                    context: context,
                    isSelected: !isPremiumUiEnabled,
                    title: 'Classic Experience',
                    subtitle: 'Traditional interface with essential features',
                    icon: Icons.straighten,
                    onTap: () async {
                      await PreferencesService.setBool('premium_ui_enabled', false);
                      if (mounted) {
                        Navigator.pop(context);
                        HapticHelper.light();
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  _buildUiOption(
                    context: context,
                    isSelected: isPremiumUiEnabled,
                    title: 'Super Ultra Premium',
                    subtitle: 'Cinematic animations, biometric-responsive design, particle effects',
                    icon: Icons.brush,
                    onTap: () async {
                      await PreferencesService.setBool('premium_ui_enabled', true);
                      if (mounted) {
                        Navigator.pop(context);
                        HapticHelper.light();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticHelper.light();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusLarge),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUiOption({
    required BuildContext context,
    required bool isSelected,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: AppDurations.standard,
      curve: AppCurves.premiumFluid,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.space16.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Icon(
                    icon,
                    size: 24.sp,
                    color: isSelected ? AppColors.onPrimary : AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSpacing.space16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppTextColors.primary,
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
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  size: 24.sp,
                  color: isSelected ? AppColors.success : AppTextColors.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fades and slides its child up once, on first build after data loads.
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

/// Fades and slides in a list item with an index-based stagger delay.
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
