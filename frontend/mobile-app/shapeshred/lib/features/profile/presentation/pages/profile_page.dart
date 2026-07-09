import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/profile/presentation/pages/body_composition_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/profile_photo_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/privacy_settings_page.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_history_page.dart';

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

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColorPalette.pureWhite,
        body: Center(
          child: Text(
            'Please login first',
            style: AppTypography.bodyLarge,
          ),
        ),
      );
    }

    final displayName = user.displayName ?? user.email?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColorPalette.gray900,
          ),
        ),
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.w,
          vertical: AppSpacing.space16.h,
        ),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColorPalette.gray200,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Icon(
                            Icons.person,
                            size: 60.sp,
                            color: AppColorPalette.gray500,
                          )
                        : null,
                  ),
                  // Optional: Add a camera icon for changing photo
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space12.h),
            Text(
              displayName,
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              user.email ?? 'No email',
              style: AppTypography.bodyMedium.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space4.h),
            // Motivational Message
            Text(
              _motivationalMessage,
              style: AppTypography.bodyLarge.copyWith(
                color: AppTextColor.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.space24.h),

            // Stats Grid
            Container(
              padding: EdgeInsets.all(AppSpacing.space16.w),
              decoration: BoxDecoration(
                color: AppColorPalette.gray50,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Height',
                      _height != null ? '${_height!.toStringAsFixed(0)} cm' : '--'),
                  _buildStat('Weight',
                      _weight != null ? '${_weight!.toStringAsFixed(1)} kg' : '--'),
                  _buildStat('Age',
                      _age != null ? '$_age years' : '--'),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),

            // Goal & Fitness Level
            Container(
              padding: EdgeInsets.all(AppSpacing.space16.w),
              decoration: BoxDecoration(
                color: AppColorPalette.pureWhite,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                border: Border.all(color: AppColorPalette.gray200, width: 1),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Goal',
                      _goal?.toUpperCase() ?? 'Not set'),
                  Divider(color: AppColorPalette.gray200, height: AppSpacing.space8.h),
                  _buildInfoRow('Fitness Level',
                      _fitnessLevel?.toUpperCase() ?? 'Not set'),
                  Divider(color: AppColorPalette.gray200, height: AppSpacing.space8.h),
                  _buildInfoRow('Gender',
                      _gender?.toUpperCase() ?? 'Not set'),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space24.h),

            // Professional Features Section
            Text(
              'Professional Features',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.space12.h),
            _buildFeatureCard(
              icon: Icons.chat_bubble_outline,
              title: 'Chat with Coach',
              subtitle: 'Get personalized guidance',
              onTap: () {
                HapticHelper.light();
                _showCoachChatDialog();
              },
            ),
            SizedBox(height: AppSpacing.space8.h),
            _buildFeatureCard(
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
            SizedBox(height: AppSpacing.space8.h),
            _buildFeatureCard(
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
            SizedBox(height: AppSpacing.space8.h),
            _buildFeatureCard(
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
            SizedBox(height: AppSpacing.space8.h),
            _buildFeatureCard(
              icon: Icons.restaurant_menu,
              title: 'Nutrition Tracking',
              subtitle: 'Log your meals',
              onTap: () {
                HapticHelper.light();
                // TODO: Navigate to nutrition page when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.space8.h),
            _buildFeatureCard(
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
            SizedBox(height: AppSpacing.space24.h),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  if (mounted) context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorPalette.gray900,
                  foregroundColor: AppColorPalette.pureWhite,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.space16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                  ),
                ),
                child: Text(
                  'Sign Out',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              'ShapeShred v1.0.0',
              style: AppTypography.bodySmall.copyWith(
                color: AppColorPalette.gray400,
              ),
            ),
          ],
        ),
      ),
    );
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
            color: AppTextColor.secondary,
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
              color: AppTextColor.secondary,
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
          color: AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColorPalette.gray200),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColorPalette.gray50,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: AppColorPalette.gray900,
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
                      color: AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColorPalette.gray300,
            ),
          ],
        ),
      ),
    );
  }

  void _showCoachChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Chat with Coach',
          style: AppTypography.headlineSmall,
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
                        color: AppColorPalette.success,
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTextColor.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticHelper.light();
              Navigator.pop(context);
            },
            child: Text(
              'Got it',
              style: AppTypography.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}