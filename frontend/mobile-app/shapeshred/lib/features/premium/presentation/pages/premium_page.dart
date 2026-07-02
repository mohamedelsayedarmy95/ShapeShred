import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/constants/app_colors.dart';
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title:
            const Text('Go Premium', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
            color: AppColors.black,
            child: Column(
              children: [
                Icon(Icons.star, color: AppColors.white, size: 48.sp),
                SizedBox(height: 8.h),
                Text(
                  'Unlock Your Full Potential',
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Get access to all premium features including live coaching, AI workouts, and personalized nutrition.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey300),
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
                    'What you\'ll get:',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                  SizedBox(height: 12.h),
                  _buildFeature(Icons.person, 'Live 1-on-1 Coaching'),
                  _buildFeature(Icons.fitness_center, 'AI-Powered Workouts'),
                  _buildFeature(Icons.restaurant, 'Custom Nutrition Plans'),
                  _buildFeature(Icons.video_call, 'Video Call Support'),
                  _buildFeature(Icons.insert_chart, 'Progress Analytics'),
                  SizedBox(height: 16.h),
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
                  // Subscribe Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white)
                          : Text(
                              'Subscribe Now',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Cancel anytime. No commitment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.grey500),
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
          Icon(icon, color: AppColors.black, size: 20.sp),
          SizedBox(width: 12.w),
          Text(label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.black)),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = _selectedPlanId == plan.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlanId = plan.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.grey200,
            width: isSelected ? 2 : 1,
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
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.white : AppColors.black,
                        ),
                      ),
                      if (plan.isPopular)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Best Value',
                              style: TextStyle(
                                  fontSize: 10.sp, color: AppColors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? AppColors.grey300 : AppColors.grey500,
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
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                ),
                Text(
                  plan.periodLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSelected ? AppColors.grey400 : AppColors.grey500,
                  ),
                ),
                if (plan.discountLabel.isNotEmpty)
                  Text(
                    plan.discountLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment
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
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.setBool('isPremium', true));
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('?? Welcome to Premium!')),
      );
      context.go('/');
    }
    setState(() => _isLoading = false);
  }
}
