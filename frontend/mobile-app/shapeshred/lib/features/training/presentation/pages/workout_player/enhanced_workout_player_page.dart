import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/design_system/atoms/rest_timer.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';

class EnhancedWorkoutPlayerPage extends StatefulWidget {
  final CustomWorkout workout;

  const EnhancedWorkoutPlayerPage({
    super.key,
    required this.workout,
  });

  @override
  State<EnhancedWorkoutPlayerPage> createState() => _EnhancedWorkoutPlayerPageState();
}

class _EnhancedWorkoutPlayerPageState extends State<EnhancedWorkoutPlayerPage> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _completedReps = 0;
  double? _loggedWeight;
  int _rpe = 5;
  bool _isResting = false;
  bool _isWorkoutComplete = false;
  
  Timer? _exerciseTimer;
  int _exerciseDuration = 0;
  
  final Map<String, dynamic> _workoutLog = {
    'exercises': <Map<String, dynamic>>[],
    'totalDuration': 0,
    'caloriesBurned': 0,
    'completedAt': null,
  };

  @override
  void initState() {
    super.initState();
    _startExerciseTimer();
  }

  @override
  void dispose() {
    _exerciseTimer?.cancel();
    super.dispose();
  }

  WorkoutExercise get _currentExercise => widget.workout.exercises[_currentExerciseIndex];
  Exercise get _exercise => _currentExercise.exercise;

  void _startExerciseTimer() {
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _exerciseDuration++;
          _workoutLog['totalDuration'] = _exerciseDuration;
        });
      }
    });
  }

  void _completeSet() {
    HapticHelper.success();
    
    setState(() {
      _workoutLog['exercises'].add({
        'exerciseId': _exercise.id,
        'exerciseName': _exercise.name,
        'set': _currentSet,
        'reps': _completedReps,
        'weight': _loggedWeight,
        'rpe': _rpe,
        'duration': _exerciseDuration,
        'completedAt': DateTime.now().toIso8601String(),
      });

      if (_currentSet < _currentExercise.sets) {
        _currentSet++;
        _completedReps = 0;
        _showRestTimer();
      } else {
        _completeExercise();
      }
    });
  }

  void _completeExercise() {
    HapticHelper.success();
    
    if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
        _completedReps = 0;
        _loggedWeight = null;
        _exerciseDuration = 0;
      });
    } else {
      _completeWorkout();
    }
  }

  void _completeWorkout() {
    _exerciseTimer?.cancel();
    HapticHelper.success();
    
    setState(() {
      _isWorkoutComplete = true;
      _workoutLog['completedAt'] = DateTime.now().toIso8601String();
      _workoutLog['caloriesBurned'] = _calculateCalories();
    });

    _saveWorkoutToHistory();
  }

  int _calculateCalories() {
    // Simple calorie estimation based on duration and intensity
    final baseCalories = _workoutLog['totalDuration'] as int;
    return (baseCalories * 0.1).round();
  }

  Future<void> _saveWorkoutToHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workout_history')
          .add({
        'name': widget.workout.name,
        'description': widget.workout.description,
        'category': widget.workout.category,
        'duration': (_workoutLog['totalDuration'] as int) ~/ 60,
        'caloriesBurned': _workoutLog['caloriesBurned'],
        'exercises': _workoutLog['exercises'],
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving workout: $e');
    }
  }

  void _showRestTimer() {
    setState(() => _isResting = true);
    
    RestTimerDialog.show(
      context,
      duration: 60, // 60 seconds rest
      onTimerComplete: () {
        setState(() => _isResting = false);
      },
      onSkip: () {
        setState(() => _isResting = false);
      },
    );
  }

  void _skipExercise() {
    HapticHelper.light();
    _completeExercise();
  }

  void _endWorkout() {
    _exerciseTimer?.cancel();
    HapticHelper.light();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isWorkoutComplete) {
      return _buildCompletionScreen();
    }

    if (_isResting) {
      return _buildRestingScreen();
    }

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColorPalette.gray900),
          onPressed: _endWorkout,
        ),
        title: Text(
          widget.workout.name,
          style: AppTypography.headlineSmall,
        ),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space12.w,
                vertical: AppSpacing.space8.h,
              ),
              decoration: BoxDecoration(
                color: AppColorPalette.gray100,
                borderRadius: BorderRadius.circular(AppRadius.radiusPill),
              ),
              child: Text(
                '${_currentExerciseIndex + 1}/${widget.workout.exercises.length}',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.space16.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: (_currentExerciseIndex + _currentSet / _currentExercise.sets) / widget.workout.exercises.length,
                backgroundColor: AppColorPalette.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColorPalette.gray900),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Exercise Info
              Text(
                _exercise.name,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                _exercise.muscleGroup,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Set Counter
              Container(
                padding: EdgeInsets.all(AppSpacing.space16.w),
                decoration: BoxDecoration(
                  color: AppColorPalette.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set $_currentSet of ${_currentExercise.sets}',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_exercise.reps} reps',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Rep Counter
              _buildRepCounter(),
              SizedBox(height: AppSpacing.space24.h),

              // Weight Input
              _buildWeightInput(),
              SizedBox(height: AppSpacing.space24.h),

              // RPE Slider
              _buildRPESlider(),
              SizedBox(height: AppSpacing.space24.h),

              // Form Tips
              _buildFormTips(),
              SizedBox(height: AppSpacing.space32.h),

              // Complete Set Button
              PremiumButton(
                label: 'Complete Set',
                onPressed: _completeSet,
                fullWidth: true,
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Skip Button
              OutlinedButton(
                onPressed: _skipExercise,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColorPalette.gray200),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
                child: Text(
                  'Skip Exercise',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColorPalette.gray700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepCounter() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        color: AppColorPalette.gray50,
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
      ),
      child: Column(
        children: [
          Text(
            'Reps Completed',
            style: AppTypography.labelMedium.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRepButton(
                icon: Icons.remove,
                onTap: () {
                  if (_completedReps > 0) {
                    setState(() => _completedReps--);
                    HapticHelper.light();
                  }
                },
              ),
              SizedBox(width: AppSpacing.space32.w),
              Text(
                '$_completedReps',
                style: AppTypography.displayLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppSpacing.space32.w),
              _buildRepButton(
                icon: Icons.add,
                onTap: () {
                  if (_completedReps < _exercise.reps) {
                    setState(() => _completedReps++);
                    HapticHelper.light();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'Target: ${_exercise.reps} reps',
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusCircle),
          boxShadow: [
            BoxShadow(
              color: AppColorPalette.gray900.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 24.sp),
      ),
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (kg) - Optional',
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.space8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
          decoration: BoxDecoration(
            color: AppColorPalette.gray50,
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter weight',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppTextColor.secondary,
              ),
              suffixText: 'kg',
            ),
            onChanged: (value) {
              _loggedWeight = double.tryParse(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRPESlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate of Perceived Exertion (RPE)',
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.space8.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _rpe.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_rpe',
                activeColor: AppColorPalette.gray900,
                onChanged: (value) {
                  setState(() => _rpe = value.round());
                  HapticHelper.light();
                },
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getRPEColor(_rpe),
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Center(
                child: Text(
                  '$_rpe',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space8.h),
        Text(
          _getRPELabel(_rpe),
          style: AppTypography.bodySmall.copyWith(
            color: AppTextColor.secondary,
          ),
        ),
      ],
    );
  }

  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColorPalette.success;
    if (rpe <= 6) return AppColorPalette.warning;
    return AppColorPalette.error;
  }

  String _getRPELabel(int rpe) {
    if (rpe <= 3) return 'Light';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Very Hard';
  }

  Widget _buildFormTips() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColorPalette.gray50,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColorPalette.gray700,
                size: 20.sp,
              ),
              SizedBox(width: AppSpacing.space8.w),
              Text(
                'Form Tips',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space12.h),
          ..._exercise.instructions.take(3).map((tip) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.space8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16.sp,
                      color: AppColorPalette.gray700,
                    ),
                    SizedBox(width: AppSpacing.space8.w),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppTextColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRestingScreen() {
    return Scaffold(
      backgroundColor: AppColorPalette.gray900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer,
              size: 64.sp,
              color: AppColorPalette.pureWhite,
            ),
            SizedBox(height: AppSpacing.space16.h),
            Text(
              'Rest Period',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColorPalette.pureWhite,
              ),
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              'Take a breather before the next set',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColorPalette.gray300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 100.sp,
                color: AppColorPalette.success,
              ),
              SizedBox(height: AppSpacing.space32.h),
              Text(
                'Workout Complete!',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),
              Text(
                widget.workout.name,
                style: AppTypography.titleLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space32.h),
              _buildStatCard(
                label: 'Duration',
                value: '${(_workoutLog['totalDuration'] as int) ~/ 60}m',
                icon: Icons.access_time,
              ),
              SizedBox(height: AppSpacing.space16.h),
              _buildStatCard(
                label: 'Calories Burned',
                value: '${_workoutLog['caloriesBurned']} cal',
                icon: Icons.local_fire_department,
              ),
              SizedBox(height: AppSpacing.space16.h),
              _buildStatCard(
                label: 'Exercises',
                value: '${widget.workout.exercises.length}',
                icon: Icons.fitness_center,
              ),
              SizedBox(height: AppSpacing.space32.h),
              PremiumButton(
                label: 'Back to Home',
                onPressed: () {
                  HapticHelper.success();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String label, required String value, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColorPalette.gray50,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32.sp, color: AppColorPalette.gray700),
          SizedBox(width: AppSpacing.space16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  value,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
