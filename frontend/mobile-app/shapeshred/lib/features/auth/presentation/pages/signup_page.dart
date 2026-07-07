import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/widgets/social_login_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColorPalette.gray900,
                  size: 20.sp,
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Header
              Text(
                'Create account',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'Start your fitness journey today',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space32.h),

              // Name Input
              TextField(
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppTextColor.secondary,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColorPalette.gray500,
                  ),
                  filled: true,
                  fillColor: AppColorPalette.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(
                      color: AppColorPalette.gray900,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Email Input
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppTextColor.secondary,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColorPalette.gray500,
                  ),
                  filled: true,
                  fillColor: AppColorPalette.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(
                      color: AppColorPalette.gray900,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Password Input
              TextField(
                obscureText: true,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppTextColor.secondary,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColorPalette.gray500,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility_outlined,
                    color: AppColorPalette.gray500,
                  ),
                  filled: true,
                  fillColor: AppColorPalette.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(
                      color: AppColorPalette.gray900,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Confirm Password Input
              TextField(
                obscureText: true,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppTextColor.secondary,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColorPalette.gray500,
                  ),
                  filled: true,
                  fillColor: AppColorPalette.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    borderSide: BorderSide(
                      color: AppColorPalette.gray900,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Terms Checkbox
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                    activeColor: AppColorPalette.gray900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySmall,
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: AppColorPalette.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColorPalette.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Signup Button
              Container(
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
                      'CREATE ACCOUNT',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColorPalette.pureWhite,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColorPalette.gray200)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'OR',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColorPalette.gray200)),
                ],
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Social Signup Buttons
              SocialLoginButton(
                icon: Icons.g_mobiledata,
                label: 'Sign up with Google',
                onTap: () {},
              ),
              SizedBox(height: AppSpacing.space12.h),
              SocialLoginButton(
                icon: Icons.apple,
                label: 'Sign up with Apple',
                onTap: () {},
              ),
              SizedBox(height: AppSpacing.space32.h),
            ],
          ),
        ),
      ),
    );
  }
}
