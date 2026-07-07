import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/app_button.dart';
import 'package:shapeshred/core/design_system/atoms/app_input.dart';
import 'package:shapeshred/core/design_system/atoms/app_back_button.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text(
              l10n.welcomeBack,
              style: AppTypography.textTheme.displaySmall,
            ),
            SizedBox(height: AppSpacing.elementSpacing.h),
            Text(
              'Sign in to continue your fitness journey.',
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: 48.h),
            AppInput(
              label: 'Email Address',
              hintText: 'name@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppSpacing.space16.h),
            AppInput(
              label: 'Password',
              hintText: '••••••••',
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.space32.h),
            AppButton(
              text: 'Sign In',
              isLoading: _isLoading,
              onPressed: () {
                // TODO: Implement actual login
                context.go('/home');
              },
            ),
            SizedBox(height: AppSpacing.space24.h),
            Center(
              child: Text(
                'OR CONTINUE WITH',
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: AppTextColor.tertiary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.space24.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Google',
                    variant: AppButtonVariant.outline,
                    onPressed: _signInWithGoogle,
                  ),
                ),
                SizedBox(width: AppSpacing.space12.w),
                Expanded(
                  child: AppButton(
                    text: 'Apple',
                    variant: AppButtonVariant.outline,
                    onPressed: _signInWithApple,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.space24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.dontHaveAccount,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: Text(
                    l10n.signup,
                    style: AppTypography.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
