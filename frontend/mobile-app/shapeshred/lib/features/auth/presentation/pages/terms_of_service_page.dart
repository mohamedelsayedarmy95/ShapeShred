import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColorPalette.gray900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms of Service',
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
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space24.h),

            _buildSection(
              '1. Acceptance of Terms',
              '''
By accessing or using ShapeShred, you agree to be bound by these Terms of Service and all applicable laws and regulations.
''',
            ),

            _buildSection(
              '2. Use License',
              '''
Permission is granted to temporarily download one copy of the materials on ShapeShred for personal, non-commercial transitory viewing only.
''',
            ),

            _buildSection(
              '3. Disclaimer',
              '''
The materials on ShapeShred are provided on an 'as is' basis. ShapeShred makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.
''',
            ),

            _buildSection(
              '4. Limitations',
              '''
In no event shall ShapeShred or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on ShapeShred.
''',
            ),

            _buildSection(
              '5. Revisions and Errata',
              '''
The materials appearing on ShapeShred could include technical, typographical, or photographic errors. ShapeShred does not warrant that any of the materials on its web site are accurate, complete or current.
''',
            ),

            _buildSection(
              '6. Links',
              '''
ShapeShred has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by ShapeShred of the site.
''',
            ),

            _buildSection(
              '7. Modifications',
              '''
ShapeShred may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the then current version of these terms of service.
''',
            ),

            _buildSection(
              '8. Governing Law',
              '''
These terms and conditions are governed by and construed in accordance with the laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location.
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
              color: AppTextColor.secondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
