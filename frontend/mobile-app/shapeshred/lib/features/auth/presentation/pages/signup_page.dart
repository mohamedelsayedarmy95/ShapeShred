import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/password_strength_indicator.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/services/auth_service.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'body_metrics_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate inputs
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        throw Exception('Please fill in all fields');
      }

      // Email format validation
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        throw Exception('Please enter a valid email address');
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }

      if (_passwordController.text.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Sign up with Firebase
      final userCredential = await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null && mounted) {
        HapticHelper.success();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account created successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to body metrics page
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (context) => const BodyMetricsPage()),
          );
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
              // Header
              Text(
                'Create Account',
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
                onChanged: (_) => setState(() {}),
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
              
              // Password Strength Indicator
              PasswordStrengthIndicator(
                password: _passwordController.text,
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Confirm Password Input
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColorPalette.gray500,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
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
              SizedBox(height: AppSpacing.space24.h),

              // Sign Up Button
              PremiumButton(
                label: 'CREATE ACCOUNT',
                onPressed: _handleSignup,
                isLoading: _isLoading,
                fullWidth: true,
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

              // Google Sign In Button
              _SocialButton(
                icon: Icons.g_mobiledata,
                label: 'Continue with Google',
                onTap: () async {
                  try {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    final userCredential = await _authService.signInWithGoogle();
                    
                    if (userCredential != null && mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(builder: (context) => const BodyMetricsPage()),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessage = 'Google Sign-In failed: ${e.toString()}';
                    });
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: AppSpacing.space12.h),

              // Sign In Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Sign in',
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColorPalette.gray200),
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp),
            SizedBox(width: AppSpacing.space12.w),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
