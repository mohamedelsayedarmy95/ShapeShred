import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/pages/signup_page.dart';
import 'package:shapeshred/features/auth/presentation/widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              // Logo/Brand
              Center(
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColorPalette.gray900, AppColorPalette.gray700],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: AppColorPalette.pureWhite,
                    size: 40.sp,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Header
              Text(
                'Welcome back',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'Sign in to continue your journey',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Email Input
              TextField(
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
              SizedBox(height: AppSpacing.space8.h),

              // Forgot Password
              // TODO: Implement forgot password functionality
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: Text(
              //       'Forgot password?',
              //       style: AppTypography.labelLarge.copyWith(
              //         color: AppColorPalette.gray700,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: AppSpacing.space16.h),

              // Login Button
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
                      'SIGN IN',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColorPalette.pureWhite,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space20.h),

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
              SizedBox(height: AppSpacing.space20.h),

              // Social Login Buttons
              // TODO: Implement social login functionality
              // SocialLoginButton(
              //   icon: Icons.g_mobiledata,
              //   label: 'Continue with Google',
              //   onTap: () {},
              // ),
              // SizedBox(height: AppSpacing.space12.h),
              // SocialLoginButton(
              //   icon: Icons.apple,
              //   label: 'Continue with Apple',
              //   onTap: () {},
              // ),
              // SizedBox(height: AppSpacing.space12.h),
              // SocialLoginButton(
              //   icon: Icons.facebook,
              //   label: 'Continue with Facebook',
              //   onTap: () {},
              // ),
              SizedBox(height: AppSpacing.space24.h),

              // Sign Up Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColorPalette.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
