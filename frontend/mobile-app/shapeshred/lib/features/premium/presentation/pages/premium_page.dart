import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/press_feedback.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/premium/domain/entities/subscription_plan_entity.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  String _selectedPlanId = 'monthly';
  bool _isLoading = false;

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'monthly',
      name: 'Monthly',
      price: 19.99,
      period: 'month',
      description: 'Full access for 30 days.',
    ),
    SubscriptionPlan(
      id: 'quarterly',
      name: 'Quarterly',
      price: 47.99,
      period: '3 months',
      description: 'Save 20% with quarterly plan.',
      isPopular: true,
      discount: 0.20,
    ),
    SubscriptionPlan(
      id: 'yearly',
      name: 'Yearly',
      price: 143.99,
      period: '12 months',
      description: 'Save 40% with annual plan.',
      discount: 0.40,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      appBar: AppBar(
        title: const Text('Go Premium'),
        leading: PressFeedback(
          onTap: () {
            HapticHelper.light();
            context.pop();
          },
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppSurfaceLevel.elevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppColorPalette.gray200),
            ),
            child: Icon(Icons.close_rounded, size: 20.sp, color: AppTextColor.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColorPalette.gray900, AppColorPalette.gray800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.stars_rounded, color: AppColorPalette.pureWhite, size: 48.sp),
                SizedBox(height: 16.h),
                Text(
                  'Unlock Your Full Potential',
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Get access to all premium features including live coaching, AI workouts, and personalized nutrition.',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColorPalette.gray400,
                  ),
                ),
              ],
            ),
          ),
          // Feature List
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Benefits',
                    style: AppTypography.textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  _buildFeature(Icons.person_rounded, 'Live 1-on-1 Coaching'),
                  _buildFeature(Icons.bolt_rounded, 'AI-Powered Workouts'),
                  _buildFeature(Icons.restaurant_rounded, 'Custom Nutrition Plans'),
                  _buildFeature(Icons.analytics_rounded, 'Progress Analytics'),
                  SizedBox(height: 24.h),
                  // Plan Selection
                  Expanded(
                    child: ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        final plan = _plans[index];
                        return _buildPlanCard(plan);
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Subscribe Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _subscribe,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColorPalette.pureWhite),
                            )
                          : const Text('Subscribe Now'),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'Cancel anytime. No commitment.',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: AppTextColor.tertiary,
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
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, color: AppColorPalette.gray900, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTypography.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = _selectedPlanId == plan.id;
    return PressFeedback(
      onTap: () => setState(() => _selectedPlanId = plan.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColorPalette.gray900 : AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
            width: 1.5,
          ),
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
                        plan.name,
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppColorPalette.pureWhite : AppTextColor.primary,
                        ),
                      ),
                      if (plan.isPopular)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColorPalette.gray700 : AppColorPalette.gray900,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: const Text(
                              'Best Value',
                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    plan.description,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: isSelected ? AppColorPalette.gray400 : AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.priceLabel,
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColorPalette.pureWhite : AppTextColor.primary,
                  ),
                ),
                Text(
                  plan.periodLabel,
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColorPalette.gray400 : AppTextColor.secondary,
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
    await Future<void>.delayed(const Duration(seconds: 2)); // Simulate payment
    final selectedPlan = _plans.firstWhere((p) => p.id == _selectedPlanId);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isPremium': true,
        'plan': selectedPlan.id,
        'expiryDate': DateTime.now().add(const Duration(days: 30)),
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremium', true);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome to Premium!')),
      );
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
