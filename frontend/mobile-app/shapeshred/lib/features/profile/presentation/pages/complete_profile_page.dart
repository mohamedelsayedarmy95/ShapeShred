import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/design_system/atoms/premium_text_field.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedGender = 'Male';
  String _selectedGoal = 'Lose Weight';
  String _selectedActivityLevel = 'Beginner';
  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _goals = [
    'Lose Weight',
    'Build Muscle',
    'Stay Fit',
    'Improve Endurance',
    'Increase Flexibility',
  ];
  final List<String> _activityLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      HapticHelper.error();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'goal': _selectedGoal,
        'activityLevel': _selectedActivityLevel,
        'completedOnboarding': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        HapticHelper.success();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile saved successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            backgroundColor: AppColorPalette.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorPalette.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Complete Your Profile',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.space16.h),
                
                // Progress Indicator
                LinearProgressIndicator(
                  value: 0.33,
                  backgroundColor: AppColorPalette.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColorPalette.gray900),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  'Step 1 of 3',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space32.h),

                // Name Field
                PremiumTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Age Field
                PremiumTextField(
                  label: 'Age',
                  hint: 'Enter your age',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 100) {
                      return 'Please enter a valid age (13-100)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Gender Selection
                Text(
                  'Gender',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColorPalette.gray50,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Column(
                    children: _genders.map((gender) {
                      return RadioListTile<String>(
                        title: Text(
                          gender,
                          style: AppTypography.bodyMedium,
                        ),
                        value: gender,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                          HapticHelper.light();
                        },
                        activeColor: AppColorPalette.gray900,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Height Field
                PremiumTextField(
                  label: 'Height (cm)',
                  hint: 'Enter your height',
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Please enter a valid height (100-250 cm)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Weight Field
                PremiumTextField(
                  label: 'Weight (kg)',
                  hint: 'Enter your weight',
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 30 || weight > 200) {
                      return 'Please enter a valid weight (30-200 kg)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Goal Selection
                Text(
                  'Fitness Goal',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Wrap(
                  spacing: AppSpacing.space8.w,
                  runSpacing: AppSpacing.space8.h,
                  children: _goals.map((goal) {
                    final isSelected = _selectedGoal == goal;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedGoal = goal);
                        HapticHelper.light();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space16.w,
                          vertical: AppSpacing.space12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColorPalette.gray900
                              : AppColorPalette.gray50,
                          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                          border: Border.all(
                            color: isSelected
                                ? AppColorPalette.gray900
                                : AppColorPalette.gray200,
                          ),
                        ),
                        child: Text(
                          goal,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColorPalette.pureWhite
                                : AppColorPalette.gray900,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Activity Level Selection
                Text(
                  'Activity Level',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColorPalette.gray50,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Column(
                    children: _activityLevels.map((level) {
                      return RadioListTile<String>(
                        title: Text(
                          level,
                          style: AppTypography.bodyMedium,
                        ),
                        subtitle: Text(
                          _getActivityLevelDescription(level),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTextColor.secondary,
                          ),
                        ),
                        value: level,
                        groupValue: _selectedActivityLevel,
                        onChanged: (value) {
                          setState(() {
                            _selectedActivityLevel = value!;
                          });
                          HapticHelper.light();
                        },
                        activeColor: AppColorPalette.gray900,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: AppSpacing.space32.h),

                // Save Button
                PremiumButton(
                  label: 'Continue',
                  onPressed: _saveProfile,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),
                SizedBox(height: AppSpacing.space16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getActivityLevelDescription(String level) {
    switch (level) {
      case 'Beginner':
        return 'New to fitness or exercising occasionally';
      case 'Intermediate':
        return 'Exercise regularly (1-3 times per week)';
      case 'Advanced':
        return 'Exercise frequently (4+ times per week)';
      default:
        return '';
    }
  }
}
