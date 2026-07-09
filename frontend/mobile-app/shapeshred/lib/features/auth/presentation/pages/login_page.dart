import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/features/auth/presentation/pages/onboarding_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final completed = await PreferencesService.isOnboardingComplete();
    if (!completed && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      setState(() => _isLoading = true);
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.cancelled) return;
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    try {
      setState(() => _isLoading = true);
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColorPalette.gray900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue your fitness journey.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: 48.h),
              _buildSocialButton(
                icon: Icons.g_translate,
                label: 'Continue with Google',
                backgroundColor: AppColorPalette.pureWhite,
                textColor: AppColorPalette.gray900,
                onTap: _signInWithGoogle,
              ),
              SizedBox(height: 12.h),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Continue with Facebook',
                backgroundColor: AppColorPalette.gray900,
                textColor: AppColorPalette.pureWhite,
                onTap: _signInWithFacebook,
              ),
              SizedBox(height: 12.h),
              _buildSocialButton(
                icon: Icons.apple,
                label: 'Continue with Apple',
                backgroundColor: AppColorPalette.gray900,
                textColor: AppColorPalette.pureWhite,
                onTap: _signInWithApple,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text(
                      'Sign Up',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColorPalette.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: const CircularProgressIndicator(
                    color: AppColorPalette.gray900,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : onTap,
        icon: Icon(icon, color: textColor, size: 24.sp),
        label: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: AppColorPalette.gray200, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          ),
        ),
      ),
    );
  }
}
