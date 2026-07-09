import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  String _selectedPlanId = 'quarterly';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'monthly',
      'name': 'Monthly',
      'price': 19.99,
      'period': 'month',
      'description': 'Full access for 30 days.',
      'popular': false,
      'discount': 0,
    },
    {
      'id': 'quarterly',
      'name': 'Quarterly',
      'price': 47.99,
      'period': '3 months',
      'description': 'Save 20% with quarterly plan.',
      'popular': true,
      'discount': 0.20,
    },
    {
      'id': 'yearly',
      'name': 'Yearly',
      'price': 143.99,
      'period': '12 months',
      'description': 'Save 40% with annual plan.',
      'popular': false,
      'discount': 0.40,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        title: Text(
          'Go Premium',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColorPalette.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColorPalette.gray900, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header Section - Premium Gray Gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColorPalette.gray900,
                  AppColorPalette.gray800,
                ],
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.star,
                  color: AppColorPalette.pureWhite,
                  size: 48.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Unlock Your Full Potential',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Get access to all premium features including live coaching, AI workouts, and personalized nutrition.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColorPalette.gray300,
                  ),
                ),
              ],
            ),
          ),
          // Features & Plans
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What you\'ll get:',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColorPalette.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildFeature(Icons.person, 'Live 1-on-1 Coaching'),
                  _buildFeature(Icons.fitness_center, 'AI-Powered Workouts'),
                  _buildFeature(Icons.restaurant, 'Custom Nutrition Plans'),
                  _buildFeature(Icons.video_call, 'Video Call Support'),
                  _buildFeature(Icons.insert_chart, 'Progress Analytics'),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) => _buildPlanCard(_plans[index]),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorPalette.gray900,
                        foregroundColor: AppColorPalette.pureWhite,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColorPalette.pureWhite,
                              ),
                            )
                          : Text(
                              'Subscribe Now',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColorPalette.pureWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      'Cancel anytime. No commitment.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColorPalette.gray400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColorPalette.gray900,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColorPalette.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isSelected = _selectedPlanId == plan['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedPlanId = plan['id']),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColorPalette.gray800 : AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColorPalette.gray900.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan['name'],
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
                        ),
                      ),
                      if (plan['popular'])
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColorPalette.gray900,
                              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                            ),
                            child: Text(
                              'Best Value',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColorPalette.pureWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    plan['description'],
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? AppColorPalette.gray300 : AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${plan['price'].toStringAsFixed(2)}',
                  style: AppTypography.headlineSmall.copyWith(
                    color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '/ ${plan['period']}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColorPalette.gray400 : AppTextColor.secondary,
                  ),
                ),
                if (plan['discount'] > 0)
                  Text(
                    'Save ${(plan['discount'] * 100).toInt()}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _subscribe() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful purchase
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Welcome to Premium!',
            style: AppTypography.bodyMedium.copyWith(color: AppColorPalette.pureWhite),
          ),
          backgroundColor: AppColorPalette.gray900,
        ),
      );
      Navigator.pop(context);
    }
    setState(() => _isLoading = false);
  }
}
