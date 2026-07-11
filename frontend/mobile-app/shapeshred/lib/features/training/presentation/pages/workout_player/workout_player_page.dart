import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_player/exercise_display.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_player/timer_display.dart';
import 'package:shapeshred/features/training/presentation/widgets/workout_player/progress_indicator.dart';

class WorkoutPlayerPage extends StatefulWidget {
  final Workout workout;

  const WorkoutPlayerPage({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutPlayerPage> createState() => _WorkoutPlayerPageState();
}

class _WorkoutPlayerPageState extends State<WorkoutPlayerPage> {
  int _currentExerciseIndex = 0;
  int _currentTime = 0;
  bool _isResting = false;
  bool _isPaused = false;
  Timer? _timer;

  Exercise get _currentExercise => widget.workout.exercises[_currentExerciseIndex];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentTime++;
          
          final targetTime = _isResting 
              ? _currentExercise.restDuration 
              : _currentExercise.duration;
          
          if (_currentTime >= targetTime) {
            _nextPhase();
          }
        });
      }
    });
  }

  void _nextPhase() {
    if (_isResting) {
      // Move to next exercise
      if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
        setState(() {
          _currentExerciseIndex++;
          _currentTime = 0;
          _isResting = false;
        });
      } else {
        // Workout complete
        _timer?.cancel();
        _showCompletionDialog();
      }
    } else {
      // Start rest
      setState(() {
        _currentTime = 0;
        _isResting = true;
      });
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _showCompletionDialog() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.shadow,
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
                      Icons.celebration,
                      size: 44.sp,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space16.h),
                  Text(
                    'Workout Complete!',
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                'Great job! You completed ${widget.workout.title}',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                      ),
                    ),
                    child: Text(
                      'DONE',
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

  @override
  Widget build(BuildContext context) {
    final targetTime = _isResting 
        ? _currentExercise.restDuration 
        : _currentExercise.duration;
    
    final progress = _currentTime / targetTime;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppTextColors.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  Text(
                    '${_currentExerciseIndex + 1} / ${widget.workout.exercises.length}',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            // Progress Indicator
            WorkoutProgressIndicator(
              currentExercise: _currentExerciseIndex + 1,
              totalExercises: widget.workout.exercises.length,
            ),
            SizedBox(height: AppSpacing.space24.h),

            // Exercise Display
            Expanded(
              child: AnimatedSwitcher(
                duration: AppDurations.substantial,
                switchInCurve: AppCurves.premiumFluid,
                switchOutCurve: AppCurves.premiumFluid,
                child: ExerciseDisplay(
                  key: ValueKey('$_currentExerciseIndex-$_isResting'),
                  exercise: _currentExercise,
                  isResting: _isResting,
                ),
              ),
            ),

            // Timer Display
            TimerDisplay(
              currentTime: _currentTime,
              targetTime: targetTime,
              isResting: _isResting,
            ),
            SizedBox(height: AppSpacing.space32.h),

            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: AppColors.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isResting ? AppColors.secondary : AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.space32.h),

            // Controls
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Skip Button
                  GestureDetector(
                    onTap: _nextPhase,
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Icon(
                        Icons.skip_next,
                        color: AppTextColors.primary,
                        size: 28.sp,
                      ),
                    ),
                  ),

                  // Pause/Play Button
                  GestureDetector(
                    onTap: _togglePause,
                    child: Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.heroGradient,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: AppColors.onPrimary,
                        size: 40.sp,
                      ),
                    ),
                  ),

                  // Info Button
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppTextColors.primary,
                      size: 28.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space24.h),
          ],
        ),
      ),
    );
  }
}
