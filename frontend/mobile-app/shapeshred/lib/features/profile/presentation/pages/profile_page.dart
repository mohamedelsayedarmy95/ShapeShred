import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/profile/presentation/widgets/profile_header.dart';
import 'package:shapeshred/features/profile/presentation/widgets/stats_grid.dart';
import 'package:shapeshred/features/profile/presentation/widgets/achievement_section.dart';
import 'package:shapeshred/features/profile/presentation/widgets/body_metrics_card.dart';
import 'package:shapeshred/features/profile/presentation/widgets/activity_graph.dart';
import 'package:shapeshred/features/profile/presentation/widgets/premium_card.dart';
import 'package:shapeshred/features/profile/presentation/widgets/coach_card.dart';
import 'package:shapeshred/features/profile/presentation/widgets/settings_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.w,
                  vertical: AppSpacing.space16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: AppTypography.headlineLarge,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColorPalette.gray50,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColorPalette.gray200),
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          color: AppColorPalette.gray900,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // Profile Header
                    const ProfileHeader(
                      name: 'Ahmed Hassan',
                      level: 'Elite Athlete',
                      memberSince: 'Member since Jan 2024',
                      avatarUrl: null,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Stats Grid
                    const StatsGrid(
                      workouts: 127,
                      streak: 23,
                      calories: 45820,
                      minutes: 3840,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Premium Card
                    const PremiumCard(
                      isPremium: false,
                      onUpgrade: null,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Activity Graph
                    const ActivityGraph(
                      weeklyData: [45, 60, 30, 75, 50, 90, 40],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Body Metrics
                    const BodyMetricsCard(
                      weight: 78.5,
                      height: 180,
                      bmi: 24.2,
                      bodyFat: 15.5,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Coach Card
                    const CoachCard(
                      coachName: 'Coach Sarah',
                      specialty: 'Strength & Conditioning',
                      rating: 4.9,
                      isOnline: true,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Achievements
                    const AchievementSection(
                      achievements: [
                        {'title': '7-Day Streak', 'icon': '', 'unlocked': true},
                        {'title': 'First 100', 'icon': '', 'unlocked': true},
                        {'title': 'Early Bird', 'icon': '', 'unlocked': true},
                        {'title': 'Iron Will', 'icon': '', 'unlocked': false},
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Settings List
                    SettingsList(
                      items: [
                        SettingsItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {},
                        ),
                        SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        SettingsItem(
                          icon: Icons.favorite_outline,
                          title: 'Health & Safety',
                          onTap: () {},
                        ),
                        SettingsItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                        SettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        SettingsItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'v1.0.0',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Logout Button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.space16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColorPalette.gray50,
                          borderRadius: BorderRadius.circular(AppRadius.l),
                          border: Border.all(color: AppColorPalette.gray200),
                        ),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColorPalette.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.space40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
