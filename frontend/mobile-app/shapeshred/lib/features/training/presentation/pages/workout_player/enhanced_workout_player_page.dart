import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/shadows.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/design_system/atoms/rest_timer.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/domain/models/custom_workout.dart';
import 'package:shapeshred/providers/workout_session_provider.dart';
import 'package:shapeshred/providers/firebase_providers.dart';

/// Enhanced 3D Exercise Visualization Widget
/// Would typically integrate with a 3D model viewer like flutter_unity_widget,
/// model_viewer_plus, or similar for actual 3D exercise demonstrations
class ExerciseVisualization3D extends StatefulWidget {
  final Exercise exercise;
  final bool showFormFeedback;
  final Function(Map<String, dynamic>)? onFormFeedback;

  const ExerciseVisualization3D({
    super.key,
    required this.exercise,
    this.showFormFeedback = false,
    this.onFormFeedback,
  });

  @override
  State<ExerciseVisualization3D> createState() => _ExerciseVisualization3DState();
}

class _ExerciseVisualization3DState extends State<ExerciseVisualization3D>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  bool _isCameraActive = false;
  Map<String, dynamic>? _latestFormFeedback;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Simulate starting camera for form analysis
  void _startFormAnalysis() {
    setState(() => _isCameraActive = true);
    // In a real implementation, this would initialize camera feed
    // and start pose estimation (using ML Kit, TensorFlow Lite, etc.)

    // Simulate periodic feedback
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        // Simulate form feedback data
        _latestFormBackup = {
          'depth': 0.8 + (math.Random().nextDouble() * 0.2), // 0.8-1.0
          'speed': 0.6 + (math.Random().nextDouble() * 0.4), // 0.6-1.0
          'alignment': 0.7 + (math.Random().nextDouble() * 0.3), // 0.7-1.0
          'balance': 0.5 + (math.Random().nextDouble() * 0.5), // 0.5-1.0
          'stability': 0.75 + (math.Random().nextDouble() * 0.25), // 0.75-1.0
          'timestamp': DateTime.now().toIso8601String(),
        };

        if (widget.onFormFeedback != null && _latestFormBackup != null) {
          widget.onFormFeedback!(_latestFormBackup!);
        }
      });
    });
  }

  void _stopFormAnalysis() {
    setState(() => _isCameraActive = false);
  }

  Map<String, dynamic>? _latestFormBackup;

  @override
  Widget build(BuildContext context) {
    // Determine if we should show 3D visualization or placeholder
    final bool show3D = widget.exercise.thumbnailUrl != null ||
        widget.exercise.videoUrl != null;

    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Stack(
        children: [
          // 3D Model Placeholder (would be replaced with actual 3D viewer)
          Center(
            child: show3D
                ? AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) => Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: _buildExerciseModel(),
                    ),
                  )
                : _buildExercisePlaceholder(),
          ),

          // Form Feedback Overlay
          if (widget.showFormFeedback && _isCameraActive)
            _buildFormFeedbackOverlay(),

          // Camera Active Indicator
          if (_isCameraActive)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 16.sp,
                      color: AppColors.onError,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Analyzing Form',
                      style: TextStyle(
                        color: AppColors.onError,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
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

  Widget _buildExerciseModel() {
    // This would be replaced with actual 3D model rendering
    return Container(
      width: 180.w,
      height: 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.secondary.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 48.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 8.h),
          Text(
            widget.exercise.name,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.fitness_center,
          size: 48.sp,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        SizedBox(height: 8.h),
        Text(
          '${widget.exercise.name}\n3D Model Preview',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.5),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFeedbackOverlay() {
    if (_latestFormBackup == null) {
      return Center(
        child: Text(
          'Analyzing your form...',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 14,
          ),
        ),
      );
    }

    final double overallScore = (_latestFormBackup!['depth'] as double) * 0.3 +
        (_latestFormBackup!['speed'] as double) * 0.2 +
        (_latestFormBackup!['alignment'] as double) * 0.3 +
        (_latestFormBackup!['stability'] as double) * 0.2;

    final Color scoreColor = overallScore > 0.8
        ? AppColors.success
        : overallScore > 0.6
            ? AppColors.warning
            : AppColors.error;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFormMetric('Depth', _latestFormBackup!['depth'] as double),
                _buildFormMetric('Speed', _latestFormBackup!['speed'] as double),
                _buildFormMetric(
                    'Alignment', _latestFormBackup!['alignment'] as double),
                _buildFormMetric(
                    'Stability', _latestFormBackup!['stability'] as double),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              width: 200.w,
              height: 8.h,
              decoration: BoxDecoration(
                border: Border.all(color: scoreColor),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Container(
                width: (200.w * overallScore).clamp(0.0, 200.w),
                height: 8.h,
                color: scoreColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Form Score: ${(overallScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: scoreColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormMetric(String label, double value) {
    final Color color = value > 0.8
        ? AppColors.success
        : value > 0.6
            ? AppColors.warning
            : AppColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ${(value * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: color,
            fontSize: 10.sp,
          ),
        ),
        Container(
          width: 20.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}

class EnhancedWorkoutPlayerPage extends ConsumerStatefulWidget {
  const EnhancedWorkoutPlayerPage({super.key});

  @override
  ConsumerState<EnhancedWorkoutPlayerPage> createState() => _EnhancedWorkoutPlayerPageState();
}

class _EnhancedWorkoutPlayerPageState extends ConsumerState<EnhancedWorkoutPlayerPage>
    with TickerProviderStateMixin {
  // UI-specific state (not part of the workout session logic)
  late final WorkoutBiometricsMonitor _biometrics;
  Map<String, double> _formScores = {};
  bool _showFormFeedback = false;
  bool _isCameraActive = false;
  String _lastHrZone = 'warmup';

  @override
  void initState() {
    super.initState();
    _biometrics = WorkoutBiometricsMonitor(0.5);
    _biometrics.addListener(_onBiometricChange);
    _enableFormAnalysis();
  }

  @override
  void dispose() {
    _biometrics.removeListener(_onBiometricChange);
    _biometrics.dispose();
    super.dispose();
  }

  void _onBiometricChange() {
    // Provide haptic feedback based on biometric changes
    final int hr = _biometrics.estimatedHeartRate;

    // Heart rate zone haptic feedback
    if (hr >= 160 && _lastHrZone != 'peak') {
      HapticHelper.heartRateZoneEntered('peak');
      _lastHrZone = 'peak';
    } else if (hr >= 140 && hr < 160 && _lastHrZone != 'cardio') {
      HapticHelper.heartRateZoneEntered('cardio');
      _lastHrZone = 'cardio';
    } else if (hr >= 120 && hr < 140 && _lastHrZone != 'fatburn') {
      HapticHelper.heartRateZoneEntered('fatburn');
      _lastHrZone = 'fatburn';
    } else if (hr < 120 && _lastHrZone != 'warmup') {
      HapticHelper.heartRateZoneEntered('warmup');
      _lastHrZone = 'warmup';
    }
  }

  void _enableFormAnalysis() {
    // Enable form analysis for exercises that support it
    // In reality, this would depend on available sensors/camera permissions
    setState(() => _showFormFeedback = true);
  }

  void _onFormFeedback(Map<String, dynamic> feedback) {
    // Process form feedback and provide haptic guidance
    setState(() {
      // Store historical form scores
      _formScores[DateTime.now().toIso8601String()] = (
        (feedback['depth'] as double) * 0.3 +
        (feedback['speed'] as double) * 0.2 +
        (feedback['alignment'] as double) * 0.3 +
        (feedback['stability'] as double) * 0.2
      );

      // Keep only last 10 scores
      if (_formScores.length > 10) {
        final keys = _formScores.keys.toList()..sort();
        _formScores.remove(keys.first);
      }

      // Calculate average form score for this exercise
      final double avgScore = _formScores.values.reduce((a, b) => a + b) / _formScores.length;
      // Note: We could store this in a workout log if desired, but we'll keep it simple.
    });

    // Provide haptic feedback for form correction
    final double depthScore = feedback['depth'] as double;
    final double speedScore = feedback['speed'] as double;
    final double alignmentScore = feedback['alignment'] as double;
    final double stabilityScore = feedback['stability'] as double;

    // Provide feedback for significant form issues
    if (depthScore < 0.6) {
      HapticHelper.formFeedback('depth', 1.0 - depthScore);
    }
    if (alignmentScore < 0.6) {
      HapticHelper.formFeedback('alignment', 1.0 - alignmentScore);
    }
    if (stabilityScore < 0.5) {
      HapticHelper.formFeedback('stability', 1.0 - stabilityScore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutSessionState state = ref.watch(workoutSessionProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isFinished) {
      return _buildFinishedScreen(context, state);
    }

    // Main workout UI
    return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Biometric Header
                    _buildBiometricHeader(),
                    SizedBox(height: AppSpacing.space16.h),

                    // Progress Indicator with Biometric Color
                    _buildProgressIndicator(state),
                    SizedBox(height: AppSpacing.space16.h),

                    // Exercise Info
                    _buildExerciseInfo(state.currentExercise!.exercise),
                    SizedBox(height: AppSpacing.space24.h),

                    // 3D Exercise Visualization
                    ExerciseVisualization3D(
                      exercise: state.currentExercise!.exercise,
                      showFormFeedback: _showFormFeedback,
                      onFormFeedback: _onFormFeedback,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Set Counter
                    _buildSetCounter(state),
                    SizedBox(height: AppSpacing.space24.h),

                    // Rep Counter
                    _buildRepCounter(state),
                    SizedBox(height: AppSpacing.space24.h),

                    // Weight Input
                    _buildWeightInput(),
                    SizedBox(height: AppSpacing.space24.h),

                    // RPE Slider
                    _buildRPESlider(),
                    SizedBox(height: AppSpacing.space32.h),

                    // Form Tips
                    _buildFormTips(),
                    SizedBox(height: AppSpacing.space32.h),

                    // Complete Set Button
                    PremiumButton(
                      label: 'Complete Set',
                      onPressed: () {
                        ref.read(workoutSessionProvider.notifier).completeSet();
                        HapticHelper.light();
                      },
                      fullWidth: true,
                    ),
                    SizedBox(height: AppSpacing.space16.h),

                    // Skip Button
                    OutlinedButton(
                      onPressed: () {
                        ref.read(workoutSessionProvider.notifier).skipExercise();
                        HapticHelper.light();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.outline),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                        ),
                      ),
                      child: Text(
                        'Skip Exercise',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppTextColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildBiometricHeader() {
    return ValueListenableBuilder<double>(
        valueListenable: _biometrics,
        builder: (context, value, child) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.secondary.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                    border: Border.all(
                      color: _getIntensityColor(value).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workout Intensity',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTextColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(value * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: _getIntensityColor(value),
                            ),
                          ),
                          Text(
                            'HR: ${_biometrics.estimatedHeartRate}bpm',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTextColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      _getIntensityColor(value).withValues(alpha: 0.3),
                      _getIntensityColor(value).withValues(alpha: 0.1),
                    ],
                    center: Alignment.center,
                    radius: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(
                    color: _getIntensityColor(value).withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${_biometrics.estimatedHeartRate}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: _getIntensityColor(value),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity > 0.7) return AppColors.error;
    if (intensity > 0.4) return AppColors.warning;
    return AppColors.success;
  }

  Widget _buildProgressIndicator(WorkoutSessionState state) {
    final double progress = (state.exerciseIndex +
            state.setIndex / state.currentExercise!.sets) /
        state.workout!.exercises.length;

    return SizedBox(
      height: 8.h,
      child: Stack(
        children: [
          // Background track
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          // Progress bar with biometric color
          ValueListenableBuilder<double>(
            valueListenable: _biometrics,
            builder: (context, value, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getIntensityColor(value),
                        _getIntensityColor(value).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseInfo(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.space8.h),
        Text(
          exercise.muscleGroup,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
        SizedBox(height: AppSpacing.space4.h),
        // Difficulty indicator with haptic preview
        Row(
          children: [
            Text(
              'Difficulty: ',
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColors.secondary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: _getDifficultyColor(exercise.difficulty),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                exercise.difficulty,
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
      case 'expert':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  Widget _buildSetCounter(WorkoutSessionState state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(
          color: _biometrics.value > 0.7
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.outline,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Set ${state.setIndex} of ${state.currentExercise!.sets}',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: _biometrics.value > 0.7 ? AppColors.error : AppColors.primary,
            ),
          ),
          Text(
            '${state.currentExercise!.reps} reps',
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepCounter(WorkoutSessionState state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient.map((color) => color.withValues(alpha: 0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Reps Completed',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRepButton(
                icon: Icons.remove,
                onTap: () {
                  if (state.repCount > 0) {
                    ref.read(workoutSessionProvider.notifier).decrementRep();
                    HapticHelper.light();
                  }
                },
              ),
              SizedBox(width: AppSpacing.space32.w),
              Text(
                '${state.repCount}',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppSpacing.space32.w),
              _buildRepButton(
                icon: Icons.add,
                onTap: () {
                  if (state.repCount < state.currentExercise!.reps) {
                    ref.read(workoutSessionProvider.notifier).incrementRep();
                    HapticHelper.light();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'Target: ${state.currentExercise!.reps} reps',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.85),
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
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(AppRadius.radiusCircle),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 24.sp, color: AppColors.primary),
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
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
            border: Border.all(color: AppColors.outline),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter weight',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppTextColors.tertiary,
              ),
              suffixText: 'kg',
              contentPadding: EdgeInsets.symmetric(
                vertical: AppSpacing.inputPaddingVertical,
              ),
            ),
            onChanged: (value) {
              // We don't need to store this locally; the notifier doesn't use weight.
              // If we wanted to persist weight, we'd need to extend the workout log.
              // For now, we ignore it.
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
                value: 5.0, // Placeholder - we don't store RPE in the notifier yet
                min: 1,
                max: 10,
                divisions: 9,
                label: '5',
                activeColor: AppColors.primary,
                onChanged: (value) {
                  // We don't store RPE in the notifier; if needed, extend workout log.
                  HapticHelper.light();
                },
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getRPEColor(5),
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Center(
                child: Text(
                  '5',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppTextColors.inverse,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space8.h),
        Text(
          _getRPELabel(5),
          style: AppTypography.bodySmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }

  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.warning;
    return AppColors.error;
  }

  String _getRPELabel(int rpe) {
    if (rpe <= 3) return 'Light';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Very Hard';
  }

  Widget _buildFormTips() {
    final WorkoutSessionState state = ref.watch(workoutSessionProvider);
    return Container(
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(
            color: _showFormFeedback
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.outline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTextColors.secondary,
                  size: 20.sp,
                ),
                SizedBox(width: AppSpacing.space8.w),
                Text(
                  'Form Tips',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_showFormFeedback)
                  IconButton(
                    icon: Icon(
                      Icons.videocam,
                      size: 20.sp,
                      color: _isCameraActive
                          ? AppColors.success
                          : AppTextColors.secondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCameraActive = !_isCameraActive;
                        if (_isCameraActive) {
                          HapticHelper.selectionClick();
                        } else {
                          HapticHelper.lightImpact();
                        }
                      });
                    },
                    tooltip: _isCameraActive
                        ? 'Stop Form Analysis'
                        : 'Start Form Analysis',
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.space12.h),
            ...state.currentExercise!.exercise.instructions
                .take(3)
                .map((tip) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.space8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16.sp,
                        color: AppTextColors.secondary,
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Expanded(
                        child: Text(
                          tip,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTextColors.secondary,
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

  Widget _buildFinishedScreen(BuildContext context, WorkoutSessionState state) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.3),
                        AppColors.success.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success,
                        blurRadius: 24,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 60.sp,
                        color: AppColors.success,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'COMPLETE!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
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
                  state.workout?.name ?? 'Workout',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.space24.h),

                // Workout Stats with Biometrics
                _buildStatCard(
                  label: 'Duration',
                  value: '${state.elapsed.inMinutes} min',
                  icon: Icons.access_time,
                ),
                SizedBox(height: AppSpacing.space16.h),
                _buildStatCard(
                  label: 'Calories Burned',
                  value: '${_calculateCalories(state.elapsed)} cal',
                  icon: Icons.local_fire_department,
                ),
                SizedBox(height: AppSpacing.space16.h),
                _buildStatCard(
                  label: 'Avg Heart Rate',
                  value: '${_biometrics.value > 0 ? (_biometrics.value * 200).round() : 0} bpm', // Approximation
                  icon: Icons.favorite,
                ),
                SizedBox(height: AppSpacing.space16.h),
                _buildStatCard(
                  label: 'Form Score',
                  value: _formScores.isNotEmpty
                      ? '${(_formScores.values.reduce((a, b) => a + b) / _formScores.length * 100).toStringAsFixed(0)}%'
                      : 'N/A',
                  icon: Icons.health_and_safety,
                ),
                SizedBox(height: AppSpacing.space32.h),

                // Achievement Badges
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    if ((state.workout?.exercises.length ?? 0) >= 5)
                      _buildAchievementBadge(
                          'Consistency', Icons.local_fire_department, AppColors.success),
                    if (_biometrics.value > 0.7)
                      _buildAchievementBadge(
                          'Intensity', Icons.favorite, AppColors.error),
                    if (_formScores.isNotEmpty &&
                        _formScores.values.where((score) => score > 0.8).length >= 3)
                      _buildAchievementBadge(
                          'Form Master', Icons.emoji_events, AppColors.warning),
                  ],
                ),
                SizedBox(height: AppSpacing.space32.h),
                PremiumButton(
                  label: 'Finish Workout',
                  onPressed: () {
                    HapticHelper.successImpact();
                    // Reset the selected workout provider so we don't reuse the same workout
                    ref.read(selectedWorkoutProvider.notifier).select(null);
                    // Pop to home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
    );
  }

  int _calculateCalories(Duration duration) {
    // More accurate calorie calculation using MET values and heart rate
    final double durationHours = duration.inSeconds / 3600;
    final double weightKg = 70.0; // Would come from user profile
    final double metValue = 6.0; // Moderate effort MET value
    return (metValue * weightKg * durationHours).round();
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32.sp, color: AppTextColors.secondary),
          SizedBox(width: AppSpacing.space16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
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

  Widget _buildAchievementBadge(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper class for biometric monitoring (kept from original)
// ---------------------------------------------------------------------------
class WorkoutBiometricsMonitor extends ValueNotifier<double> {
  WorkoutBiometricsMonitor(super.value); // value represents workout intensity 0.0-1.0

  bool get isHighIntensity => value > 0.7;
  bool get isRecovery => value < 0.3;

  // Simulate heart rate based on intensity
  int get estimatedHeartRate {
    // Resting HR: 60-100, Max HR: ~220 - age
    // Using simplified formula for demo
    return (60 + (value * 120)).round(); // 60-180 BPM
  }

  // Simulate fatigue level
  double get fatigueLevel => (value * 0.8).clamp(0.0, 1.0);

  // Update intensity based on workout progress
  void updateIntensity(double newIntensity) {
    value = newIntensity.clamp(0.0, 1.0);
    notifyListeners();
  }
}