import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/app_button.dart';
import 'package:shapeshred/core/design_system/atoms/app_input.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              l10n.signup,
              style: AppTypography.textTheme.displaySmall,
            ),
            SizedBox(height: AppSpacing.elementSpacing.h),
            Text(
              'Create your account to get started.',
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: 32.h),
            AppInput(
              label: 'Full Name',
              hintText: 'John Doe',
              controller: _nameController,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            SizedBox(height: AppSpacing.space16.h),
            AppInput(
              label: l10n.email,
              hintText: 'name@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            SizedBox(height: AppSpacing.space16.h),
            AppInput(
              label: l10n.password,
              hintText: '••••••••',
              controller: _passwordController,
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: const Icon(Icons.visibility_off),
            ),
            SizedBox(height: AppSpacing.space32.h),
            AppButton(
              text: l10n.signup,
              onPressed: () => context.go('/home'),
            ),
            SizedBox(height: AppSpacing.space24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.alreadyHaveAccount,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    l10n.login,
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
