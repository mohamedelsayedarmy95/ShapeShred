import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/constants/app_colors.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),
            CircleAvatar(
              radius: 60.r,
              backgroundColor: AppColors.grey200,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person, size: 60.sp, color: AppColors.grey500)
                  : null,
            ),
            SizedBox(height: 16.h),
            Text(
              user?.displayName ?? 'User',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            Text(
              user?.email ?? 'No email',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: 32.h),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: 'Language',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy & Security',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) context.go('/login');
              },
              isDanger: true,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                'ShapeShred v1.0.0',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.grey400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? Colors.red : AppColors.black, size: 22.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDanger ? Colors.red : AppColors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.grey400, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
