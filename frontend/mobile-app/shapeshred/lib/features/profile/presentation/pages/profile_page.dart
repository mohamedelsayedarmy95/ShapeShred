import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/features/authentication/presentation/bloc/auth_bloc.dart'
    as auth;
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: AppSurfaceLevel.background,
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return _buildProfileContent(context, state);
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    final profile = state.profile;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.space32.h),
          CircleAvatar(
            radius: 60.r,
            backgroundColor: AppColorPalette.gray200,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.profileImageUrl == null
                ? Icon(Icons.person,
                    size: 60.sp, color: AppColorPalette.gray500)
                : null,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            '${profile.firstName} ${profile.lastName}',
            style: AppTypography.textTheme.headlineSmall,
          ),
          Text(
            profile.email,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space32.h),
          _buildInfoGrid(profile),
          SizedBox(height: AppSpacing.space32.h),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Navigate to Edit Profile Page
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Sign Out',
            onTap: () {
              context.read<auth.AuthBloc>().add(auth.SignOutRequested());
              context.go('/login');
            },
            isDanger: true,
          ),
          SizedBox(height: AppSpacing.space48.h),
          Text(
            'ShapeShred v1.0.0',
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: AppTextColor.disabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(dynamic profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem('Height', '${profile.heightCm ?? "-"} cm'),
        _buildInfoItem('Weight', '${profile.weightKg ?? "-"} kg'),
        _buildInfoItem('Goal', (profile.goal as String?) ?? 'Set Goal'),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.textTheme.labelSmall?.copyWith(
            color: AppTextColor.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDanger ? AppColorPalette.gray800 : AppTextColor.primary,
      ),
      title: Text(
        title,
        style: AppTypography.textTheme.bodyLarge?.copyWith(
          color: isDanger ? AppColorPalette.gray800 : AppTextColor.primary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
