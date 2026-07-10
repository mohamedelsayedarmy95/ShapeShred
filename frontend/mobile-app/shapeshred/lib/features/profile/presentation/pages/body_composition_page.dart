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

class BodyCompositionPage extends StatefulWidget {
  const BodyCompositionPage({super.key});

  @override
  State<BodyCompositionPage> createState() => _BodyCompositionPageState();
}

class _BodyCompositionPageState extends State<BodyCompositionPage> {
  final _formKey = GlobalKey<FormState>();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _armsController = TextEditingController();
  final _thighsController = TextEditingController();
  final _calvesController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _armsController.dispose();
    _thighsController.dispose();
    _calvesController.dispose();
    super.dispose();
  }

  Future<void> _saveMeasurements() async {
    if (!_formKey.currentState!.validate()) {
      HapticHelper.error();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final measurements = {
        'chest': double.parse(_chestController.text),
        'waist': double.parse(_waistController.text),
        'hips': double.parse(_hipsController.text),
        'arms': double.parse(_armsController.text),
        'thighs': double.parse(_thighsController.text),
        'calves': double.parse(_calvesController.text),
        'recordedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('body_composition')
          .add(measurements);

      if (mounted) {
        HapticHelper.successImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Measurements saved successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        _formKey.currentState!.reset();
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTextColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Body Composition',
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
                
                // Info Card
                Container(
                  padding: EdgeInsets.all(AppSpacing.space16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTextColors.secondary,
                        size: 20.sp,
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Expanded(
                        child: Text(
                          'Track your body measurements to monitor your progress over time.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTextColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.space24.h),

                // Chest Measurement
                _buildMeasurementField(
                  label: 'Chest',
                  hint: 'Enter chest measurement (cm)',
                  controller: _chestController,
                  icon: Icons.accessibility,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Waist Measurement
                _buildMeasurementField(
                  label: 'Waist',
                  hint: 'Enter waist measurement (cm)',
                  controller: _waistController,
                  icon: Icons.roundabout_left,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Hips Measurement
                _buildMeasurementField(
                  label: 'Hips',
                  hint: 'Enter hips measurement (cm)',
                  controller: _hipsController,
                  icon: Icons.roundabout_right,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Arms Measurement
                _buildMeasurementField(
                  label: 'Arms',
                  hint: 'Enter arms measurement (cm)',
                  controller: _armsController,
                  icon: Icons.back_hand,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Thighs Measurement
                _buildMeasurementField(
                  label: 'Thighs',
                  hint: 'Enter thighs measurement (cm)',
                  controller: _thighsController,
                  icon: Icons.directions_run,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Calves Measurement
                _buildMeasurementField(
                  label: 'Calves',
                  hint: 'Enter calves measurement (cm)',
                  controller: _calvesController,
                  icon: Icons.directions_run,
                ),
                SizedBox(height: AppSpacing.space32.h),

                // Save Button
                PremiumButton(
                  label: 'Save Measurements',
                  onPressed: _saveMeasurements,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // History Section
                _buildHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: AppTextColors.secondary,
            ),
            SizedBox(width: AppSpacing.space8.w),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
            border: Border.all(color: AppColors.outline),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppTextColors.tertiary,
              ),
              suffixText: 'cm',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.inputPaddingHorizontal,
                vertical: AppSpacing.inputPaddingVertical,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.space24.h),
        Text(
          'Measurement History',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.space16.h),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('body_composition')
              .orderBy('recordedAt', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                padding: EdgeInsets.all(AppSpacing.space24.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48.sp,
                        color: AppTextColors.tertiary,
                      ),
                      SizedBox(height: AppSpacing.space16.h),
                      Text(
                        'No measurements yet',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppTextColors.secondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.space8.h),
                      Text(
                        'Start tracking your progress today!',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppTextColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final measurements = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final data = measurements[index].data() as Map<String, dynamic>;
                final date = (data['recordedAt'] as Timestamp).toDate();

                return Container(
                  margin: EdgeInsets.only(bottom: AppSpacing.space12.h),
                  padding: EdgeInsets.all(AppSpacing.space16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: AppTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppTextColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.space12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildHistoryItem('Chest', data['chest']),
                          _buildHistoryItem('Waist', data['waist']),
                          _buildHistoryItem('Hips', data['hips']),
                        ],
                      ),
                      SizedBox(height: AppSpacing.space8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildHistoryItem('Arms', data['arms']),
                          _buildHistoryItem('Thighs', data['thighs']),
                          _buildHistoryItem('Calves', data['calves']),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String label, dynamic value) {
    return Column(
      children: [
        Text(
          '${value?.toStringAsFixed(1) ?? '-'} cm',
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTextColors.primary,
          ),
        ),
        SizedBox(height: AppSpacing.space4.h),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }
}
