import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/services/auth_service.dart';
import 'package:shapeshred/core/services/biometric_service.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/auth/presentation/pages/signup_page.dart';
import 'package:shapeshred/features/auth/presentation/widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null && mounted) {
        HapticHelper.success();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to home
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      HapticHelper.error();
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    final hasBiometric = await BiometricService.isAvailable;
    if (!hasBiometric) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Biometric authentication not available',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColorPalette.pureWhite,
            ),
          ),
          backgroundColor: AppColorPalette.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final success = await BiometricService.authenticate(
      localizedReason: 'Authenticate to sign in',
    );

    if (success && mounted) {
      await _handleLogin();
    }
  }

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
                    borderRadius: BorderRadius.circular(AppRadius.radiusXL),
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

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      SizedBox(width: AppSpacing.space12.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              if (_errorMessage != null) SizedBox(height: AppSpacing.space16.h),

              // Email Input
              TextField(
                controller: _emailController,
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
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
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
                controller: _passwordController,
                obscureText: _obscurePassword,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColorPalette.gray500,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                      HapticHelper.light();
                    },
                  ),
                  filled: true,
                  fillColor: AppColorPalette.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    borderSide: BorderSide(color: AppColorPalette.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
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
              PremiumButton(
                label: 'SIGN IN',
                onPressed: _handleLogin,
                isLoading: _isLoading,
                fullWidth: true,
              ),
              SizedBox(height: AppSpacing.space12.h),
              
              // Biometric Login Button
              FutureBuilder(
                future: BiometricService.getBiometricTypeName(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == 'None') {
                    return const SizedBox.shrink();
                  }
                  
                  return TextButton.icon(
                    onPressed: _handleBiometricLogin,
                    icon: Icon(
                      snapshot.data == 'Face ID' ? Icons.face : Icons.fingerprint,
                      color: AppColorPalette.gray900,
                    ),
                    label: Text(
                      'Sign in with ${snapshot.data}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColorPalette.gray900,
                      ),
                    ),
                  );
                },
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
