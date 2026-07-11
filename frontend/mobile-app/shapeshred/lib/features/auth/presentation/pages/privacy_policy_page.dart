import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppTextColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: AppTypography.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.screenPadding.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColors.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space24.h),
            _buildSection(
              '1. Information We Collect',
              '''
We collect information you provide directly to us, including:
 Account information (name, email, password)
 Profile information (age, gender, height, weight)
 Fitness goals and preferences
 Workout and nutrition data
 Payment information (processed securely by third-party providers)
''',
            ),
            _buildSection(
              '2. How We Use Your Information',
              '''
We use the information we collect to:
 Provide, maintain, and improve our services
 Personalize your experience
 Process transactions and send related information
 Send you technical notices and support messages
 Respond to your comments and questions
 Develop new products and services
''',
            ),
            _buildSection(
              '3. Information Sharing',
              '''
We do not share your personal information with third parties except:
 With your consent
 To comply with legal obligations
 To protect our rights and safety
 With service providers who assist in our operations
''',
            ),
            _buildSection(
              '4. Data Security',
              '''
We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.
''',
            ),
            _buildSection(
              '5. Your Rights',
              '''
You have the right to:
 Access your personal data
 Correct inaccurate data
 Request deletion of your data
 Export your data
 Opt-out of marketing communications
''',
            ),
            _buildSection(
              '6. Contact Us',
              '''
If you have questions about this Privacy Policy, please contact us at:
privacy@shapeshred.com
''',
            ),
            SizedBox(height: AppSpacing.space32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.secondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
