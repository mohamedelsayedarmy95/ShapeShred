import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/pages/fitness_level_page.dart';

class BodyMetricsPage extends StatefulWidget {
  const BodyMetricsPage({super.key});

  @override
  State<BodyMetricsPage> createState() => _BodyMetricsPageState();
}

class _BodyMetricsPageState extends State<BodyMetricsPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Your body metrics',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'Help us calculate your personalized plan',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space32.h),

              // Gender Selection
              Text(
                'Gender',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space12.h),
              Row(
                children: [
                  Expanded(
                    child: _GenderButton(
                      label: 'Male',
                      icon: Icons.male,
                      isSelected: _selectedGender == 'male',
                      onTap: () => setState(() => _selectedGender = 'male'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.space12.w),
                  Expanded(
                    child: _GenderButton(
                      label: 'Female',
                      icon: Icons.female,
                      isSelected: _selectedGender == 'female',
                      onTap: () => setState(() => _selectedGender = 'female'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Height Input
              _MetricInput(
                controller: _heightController,
                label: 'Height',
                unit: 'cm',
                icon: Icons.height,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Weight Input
              _MetricInput(
                controller: _weightController,
                label: 'Weight',
                unit: 'kg',
                icon: Icons.monitor_weight,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Age Input
              _MetricInput(
                controller: _ageController,
                label: 'Age',
                unit: 'years',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),

              const Spacer(),

              // Continue Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FitnessLevelPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColorPalette.gray900, AppColorPalette.gray800],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorPalette.gray900.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUE',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColorPalette.pureWhite,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColorPalette.pureWhite,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColorPalette.gray900 
              : AppColorPalette.gray50,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: isSelected 
                ? AppColorPalette.gray900 
                : AppColorPalette.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColorPalette.pureWhite 
                  : AppColorPalette.gray700,
              size: 32.sp,
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: isSelected 
                    ? AppColorPalette.pureWhite 
                    : AppColorPalette.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;
  final TextInputType keyboardType;

  const _MetricInput({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.space8.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space16.w,
            vertical: AppSpacing.space4.h,
          ),
          decoration: BoxDecoration(
            color: AppColorPalette.gray50,
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(color: AppColorPalette.gray200),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColorPalette.gray500,
                size: 20.sp,
              ),
              SizedBox(width: AppSpacing.space12.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter $label',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColorPalette.gray400,
                    ),
                  ),
                ),
              ),
              Text(
                unit,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColorPalette.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
