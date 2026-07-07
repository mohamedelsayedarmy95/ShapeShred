import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _isLoading = true;
  bool _profileVisible = true;
  bool _statsVisible = true;
  bool _allowFriendRequests = true;
  bool _showActivity = true;
  bool _dataCollection = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && mounted) {
      final privacy = doc.data()?['privacy'] as Map<String, dynamic>?;
      if (privacy != null) {
        setState(() {
          _profileVisible = privacy['profileVisible'] ?? true;
          _statsVisible = privacy['statsVisible'] ?? true;
          _allowFriendRequests = privacy['allowFriendRequests'] ?? true;
          _showActivity = privacy['showActivity'] ?? true;
          _dataCollection = privacy['dataCollection'] ?? true;
        });
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'privacy': {
          'profileVisible': _profileVisible,
          'statsVisible': _statsVisible,
          'allowFriendRequests': _allowFriendRequests,
          'showActivity': _showActivity,
          'dataCollection': _dataCollection,
        },
        'privacyUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        HapticHelper.success();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Privacy settings saved!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save settings: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorPalette.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Settings',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.space16.h),

                    // Profile Visibility
                    _buildSection(
                      title: 'Profile Visibility',
                      children: [
                        _buildSwitchTile(
                          title: 'Make profile visible',
                          subtitle: 'Allow others to see your profile',
                          value: _profileVisible,
                          onChanged: (value) {
                            setState(() => _profileVisible = value);
                            HapticHelper.light();
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Show workout stats',
                          subtitle: 'Display your workout statistics',
                          value: _statsVisible,
                          onChanged: (value) {
                            setState(() => _statsVisible = value);
                            HapticHelper.light();
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Show activity feed',
                          subtitle: 'Share your recent activities',
                          value: _showActivity,
                          onChanged: (value) {
                            setState(() => _showActivity = value);
                            HapticHelper.light();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Social Settings
                    _buildSection(
                      title: 'Social Settings',
                      children: [
                        _buildSwitchTile(
                          title: 'Allow friend requests',
                          subtitle: 'Let others send you friend requests',
                          value: _allowFriendRequests,
                          onChanged: (value) {
                            setState(() => _allowFriendRequests = value);
                            HapticHelper.light();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Data Collection
                    _buildSection(
                      title: 'Data & Analytics',
                      children: [
                        _buildSwitchTile(
                          title: 'Data collection',
                          subtitle: 'Help us improve the app by collecting usage data',
                          value: _dataCollection,
                          onChanged: (value) {
                            setState(() => _dataCollection = value);
                            HapticHelper.light();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Privacy Policy
                    _buildSection(
                      title: 'Legal',
                      children: [
                        _buildLinkTile(
                          title: 'Privacy Policy',
                          subtitle: 'Learn how we protect your data',
                          icon: Icons.privacy_tip,
                          onTap: () {
                            HapticHelper.light();
                            // TODO: Navigate to privacy policy
                          },
                        ),
                        _buildLinkTile(
                          title: 'Terms of Service',
                          subtitle: 'Read our terms and conditions',
                          icon: Icons.description,
                          onTap: () {
                            HapticHelper.light();
                            // TODO: Navigate to terms of service
                          },
                        ),
                        _buildLinkTile(
                          title: 'Delete Account',
                          subtitle: 'Permanently delete your account and data',
                          icon: Icons.delete_forever,
                          isDestructive: true,
                          onTap: () {
                            HapticHelper.light();
                            _showDeleteAccountDialog();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space32.h),

                    // Save Button
                    PremiumButton(
                      label: 'Save Settings',
                      onPressed: _saveSettings,
                      isLoading: _isLoading,
                      fullWidth: true,
                    ),
                    SizedBox(height: AppSpacing.space16.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.space16.h),
        Container(
          decoration: BoxDecoration(
            color: AppColorPalette.pureWhite,
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
            border: Border.all(color: AppColorPalette.gray200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16.w,
        vertical: AppSpacing.space12.h,
      ),
      child: Row(
        children: [
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
          SizedBox(width: AppSpacing.space16.w),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColorPalette.gray900,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space12.h,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColorPalette.error : AppColorPalette.gray700,
              size: 24.sp,
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
                      color: isDestructive ? AppColorPalette.error : AppColorPalette.gray900,
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
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: AppTypography.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppSpacing.space16.h),
            Text(
              'This action cannot be undone. All your data including:',
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space8.h),
            ...['Profile information', 'Workout history', 'Nutrition logs', 'Progress data']
                .map((item) => Padding(
                      padding: EdgeInsets.only(left: AppSpacing.space8.w, bottom: AppSpacing.space4.h),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 4.sp, color: AppColorPalette.gray700),
                          SizedBox(width: AppSpacing.space8.w),
                          Text(
                            item,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppTextColor.secondary,
                            ),
                          ),
                        ],
                      ),
                    )),
            SizedBox(height: AppSpacing.space16.h),
            Text(
              'will be permanently deleted.',
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticHelper.light();
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(
                color: AppColorPalette.gray700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticHelper.light();
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorPalette.error,
              foregroundColor: AppColorPalette.pureWhite,
            ),
            child: Text(
              'Delete',
              style: AppTypography.labelMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete user account
      await user.delete();

      if (mounted) {
        HapticHelper.success();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account deleted successfully',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Navigate to login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete account: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
