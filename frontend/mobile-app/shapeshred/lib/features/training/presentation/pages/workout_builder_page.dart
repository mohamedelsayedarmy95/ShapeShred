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
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/features/training/domain/repositories/exercise_repository.dart';

class WorkoutBuilderPage extends StatefulWidget {
  const WorkoutBuilderPage({super.key});

  @override
  State<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Strength';
  final List<WorkoutExercise> _exercises = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Strength',
    'Cardio',
    'HIIT',
    'Flexibility',
    'Full Body',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int get _estimatedDuration {
    return _exercises.fold(0, (sum, we) {
      final exerciseDuration = we.duration ?? we.exercise.duration;
      return sum + (exerciseDuration * we.sets);
    });
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) {
      HapticHelper.error();
      return;
    }

    if (_exercises.isEmpty) {
      HapticHelper.error();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please add at least one exercise',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onError,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final workout = CustomWorkout(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        estimatedDuration: (_estimatedDuration / 60).ceil(),
        exercises: _exercises,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('custom_workouts')
          .doc(workout.id)
          .set(workout.toJson());

      if (mounted) {
        HapticHelper.successImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Workout saved successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save workout: ${e.toString()}',
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

  void _showExercisePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.radiusXL),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.all(AppSpacing.space16.w),
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding.w),
                child: Text(
                  'Select Exercise',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Exercise List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding.w),
                  itemCount: ExerciseRepository.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = ExerciseRepository.exercises[index];
                    return _buildExercisePickerItem(exercise);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercisePickerItem(Exercise exercise) {
    return GestureDetector(
      onTap: () {
        HapticHelper.light();
        Navigator.pop(context);
        _showExerciseConfigDialog(exercise);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space12.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 24.sp,
                color: AppTextColors.secondary,
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    exercise.muscleGroup,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTextColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseConfigDialog(Exercise exercise) {
    final setsController = TextEditingController(text: '3');
    final repsController = TextEditingController(text: '12');
    final durationController =
        TextEditingController(text: exercise.duration.toString());
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            exercise.name,
            style: AppTypography.headlineSmall,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sets',
                  style: AppTypography.labelMedium,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: TextField(
                    controller: setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.inputPaddingHorizontal,
                        vertical: AppSpacing.inputPaddingVertical,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
                Text(
                  'Reps',
                  style: AppTypography.labelMedium,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.inputPaddingHorizontal,
                        vertical: AppSpacing.inputPaddingVertical,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
                Text(
                  'Duration (seconds)',
                  style: AppTypography.labelMedium,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.inputPaddingHorizontal,
                        vertical: AppSpacing.inputPaddingVertical,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
                Text(
                  'Weight (kg) - Optional',
                  style: AppTypography.labelMedium,
                ),
                SizedBox(height: AppSpacing.space8.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.inputPaddingHorizontal,
                        vertical: AppSpacing.inputPaddingVertical,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticHelper.light();
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: AppTypography.labelMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HapticHelper.light();
                final workoutExercise = WorkoutExercise(
                  exercise: exercise,
                  sets: int.tryParse(setsController.text) ?? 3,
                  reps: int.tryParse(repsController.text) ?? 12,
                  duration: int.tryParse(durationController.text),
                  weight: weightController.text.isNotEmpty
                      ? int.tryParse(weightController.text)
                      : null,
                );
                setState(() {
                  _exercises.add(workoutExercise);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              child: Text(
                'Add',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeExercise(int index) {
    HapticHelper.light();
    setState(() {
      _exercises.removeAt(index);
    });
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
          'Create Workout',
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

                // Workout Name
                PremiumTextField(
                  label: 'Workout Name',
                  hint: 'Enter workout name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Description
                PremiumTextField(
                  label: 'Description',
                  hint: 'Describe your workout',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Category
                Text(
                  'Category',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Wrap(
                  spacing: AppSpacing.space8.w,
                  runSpacing: AppSpacing.space8.h,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        HapticHelper.light();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space16.w,
                          vertical: AppSpacing.space12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppRadius.radiusMedium),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.outline,
                          ),
                        ),
                        child: Text(
                          category,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.onPrimary
                                : AppTextColors.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: AppSpacing.space24.h),

                // Exercises Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercises',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_exercises.isNotEmpty)
                      Text(
                        '${_exercises.length} exercises',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppTextColors.secondary,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.space16.h),

                if (_exercises.isEmpty)
                  Container(
                    padding: EdgeInsets.all(AppSpacing.space24.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusMedium),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 48.sp,
                            color: AppTextColors.tertiary,
                          ),
                          SizedBox(height: AppSpacing.space16.h),
                          Text(
                            'No exercises yet',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppTextColors.secondary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.space8.h),
                          Text(
                            'Tap the button below to add exercises',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppTextColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final we = _exercises[index];
                      return _buildExerciseCard(we, index);
                    },
                  ),

                SizedBox(height: AppSpacing.space16.h),

                // Add Exercise Button
                OutlinedButton.icon(
                  onPressed: _showExercisePicker,
                  icon: Icon(Icons.add, color: AppColors.primary),
                  label: Text(
                    'Add Exercise',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusMedium),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space24.h),

                // Summary
                if (_exercises.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(AppSpacing.space16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusMedium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Duration',
                          style: AppTypography.labelMedium,
                        ),
                        Text(
                          '${_estimatedDuration ~/ 60}m ${_estimatedDuration % 60}s',
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: AppSpacing.space32.h),

                // Save Button
                PremiumButton(
                  label: 'Save Workout',
                  onPressed: _saveWorkout,
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

  Widget _buildExerciseCard(WorkoutExercise we, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.space12.h),
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  we.exercise.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  '${we.sets} sets × ${we.reps} reps${we.weight != null ? ' × ${we.weight}kg' : ''}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _removeExercise(index),
          ),
        ],
      ),
    );
  }
}
