import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorPalette.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
        title: Column(
          children: [
            Icon(
              Icons.celebration,
              size: 64.sp,
              color: AppColorPalette.gray900,
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
            color: AppTextColor.secondary,
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
                backgroundColor: AppColorPalette.gray900,
                foregroundColor: AppColorPalette.pureWhite,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.l),
                ),
              ),
              child: Text(
                'DONE',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColorPalette.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetTime = _isResting 
        ? _currentExercise.restDuration 
        : _currentExercise.duration;
    
    final progress = _currentTime / targetTime;

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
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
                        color: AppColorPalette.gray50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColorPalette.gray900,
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
              child: ExerciseDisplay(
                exercise: _currentExercise,
                isResting: _isResting,
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
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: AppColorPalette.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isResting ? AppColorPalette.gray500 : AppColorPalette.gray900,
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
                        color: AppColorPalette.gray50,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColorPalette.gray200),
                      ),
                      child: Icon(
                        Icons.skip_next,
                        color: AppColorPalette.gray900,
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
                        gradient: const LinearGradient(
                          colors: [AppColorPalette.gray900, AppColorPalette.gray800],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColorPalette.gray900.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: AppColorPalette.pureWhite,
                        size: 40.sp,
                      ),
                    ),
                  ),

                  // Info Button
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColorPalette.gray50,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColorPalette.gray200),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppColorPalette.gray900,
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
