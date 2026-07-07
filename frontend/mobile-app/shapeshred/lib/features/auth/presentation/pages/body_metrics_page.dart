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
  String? _errorMessage;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    setState(() {
      _errorMessage = null;
    });

    // Validate gender selection
    if (_selectedGender == null) {
      setState(() {
        _errorMessage = 'Please select your gender';
      });
      return;
    }

    // Validate height
    final height = double.tryParse(_heightController.text);
    if (height == null || height < 50 || height > 250) {
      setState(() {
        _errorMessage = 'Please enter a valid height (50-250 cm)';
      });
      return;
    }

    // Validate weight
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight < 30 || weight > 300) {
      setState(() {
        _errorMessage = 'Please enter a valid weight (30-300 kg)';
      });
      return;
    }

    // Validate age
    final age = int.tryParse(_ageController.text);
    if (age == null || age < 10 || age > 120) {
      setState(() {
        _errorMessage = 'Please enter a valid age (10-120 years)';
      });
      return;
    }

    // All validations passed, navigate
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FitnessLevelPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
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
              SizedBox(height: AppSpacing.space32.h),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      SizedBox(width: AppSpacing.space12.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) SizedBox(height: AppSpacing.space16.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorPalette.gray900,
                    foregroundColor: AppColorPalette.pureWhite,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'CONTINUE',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColorPalette.pureWhite,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Gender Button Widget
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
          color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray50,
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
          border: Border.all(
            color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.sp,
              color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray700,
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Metric Input Widget
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColorPalette.gray500),
            suffixIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              child: Text(
                unit,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColor.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            filled: true,
            fillColor: AppColorPalette.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
              borderSide: BorderSide(color: AppColorPalette.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
              borderSide: BorderSide(color: AppColorPalette.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
              borderSide: BorderSide(
                color: AppColorPalette.gray900,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
