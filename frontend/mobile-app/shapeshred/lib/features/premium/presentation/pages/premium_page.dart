import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage>
    with SingleTickerProviderStateMixin {
  String _selectedPlanId = 'quarterly';
  bool _isLoading = false;

  late final AnimationController _breatheController;
  late final Animation<double> _breatheScale;

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
  void initState() {
    super.initState();
    _breatheController = AnimationController(vsync: this, duration: AppDurations.epic)
      ..repeat(reverse: true);
    _breatheScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _breatheController, curve: AppCurves.premiumFluid),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Go Premium',
          style: AppTypography.headlineSmall.copyWith(
            color: AppTextColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppTextColors.primary, size: 24.sp),
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
                colors: AppColors.heroGradient,
              ),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _breatheScale,
                  builder: (context, child) => Transform.scale(
                    scale: _breatheScale.value,
                    child: child,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.onPrimary.withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onPrimary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.star,
                      color: AppColors.onPrimary,
                      size: 40.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Unlock Your Full Potential',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Get access to all premium features including live coaching, AI workouts, and personalized nutrition.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.75),
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
                      color: AppTextColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ..._buildStaggeredFeatures([
                    (Icons.person, 'Live 1-on-1 Coaching'),
                    (Icons.fitness_center, 'AI-Powered Workouts'),
                    (Icons.restaurant, 'Custom Nutrition Plans'),
                    (Icons.video_call, 'Video Call Support'),
                    (Icons.insert_chart, 'Progress Analytics'),
                  ]),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) => _StaggeredEntry(
                        index: index,
                        child: _buildPlanCard(_plans[index]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
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
                                color: AppColors.onPrimary,
                              ),
                            )
                          : Text(
                              'Subscribe Now',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.onPrimary,
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
                        color: AppTextColors.tertiary,
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

  List<Widget> _buildStaggeredFeatures(List<(IconData, String)> features) {
    return List.generate(features.length, (index) {
      final (icon, label) = features[index];
      return _StaggeredEntry(
        index: index,
        child: _buildFeature(icon, label),
      );
    });
  }

  Widget _buildFeature(IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTextColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isSelected = _selectedPlanId == plan['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedPlanId = plan['id'] as String),
      child: AnimatedContainer(
        duration: AppDurations.standard,
        curve: AppCurves.premiumFluid,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
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
                        plan['name'] as String,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
                        ),
                      ),
                      if (plan['popular'] as bool)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.onPrimary.withValues(alpha: 0.2)
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                            ),
                            child: Text(
                              'Best Value',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    plan['description'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? AppColors.onPrimary.withValues(alpha: 0.75) : AppTextColors.secondary,
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
                    color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '/ ${plan['period']}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColors.onPrimary.withValues(alpha: 0.7) : AppTextColors.secondary,
                  ),
                ),
                if ((plan['discount'] as num) > 0)
                  Text(
                    'Save ${(plan['discount'] * 100).toInt()}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppTextColors.secondary,
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
      setState(() => _isLoading = false);
      await _showWelcomeDialog();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _showWelcomeDialog() {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: AppDurations.cinematic,
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppCurves.premiumBounce);
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: ScaleTransition(
            scale: curved,
            child: AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusXL),
              ),
              title: Column(
                children: [
                  Container(
                    width: 88.w,
                    height: 88.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.heroGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      size: 44.sp,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  Text(
                    'Welcome to Premium!',
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                'All premium features are now unlocked. Let\'s get to work.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                      ),
                    ),
                    child: Text(
                      'LET\'S GO',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fades and slides in a list item with an index-based stagger delay.
class _StaggeredEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredEntry({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.standard +
          Duration(milliseconds: index * AnimationStaggerConfig.delay),
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
