import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/design_system/atoms/premium_card.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/presentation/widgets/form_tracker_overlay.dart';
import 'package:shapeshred/providers/workout_session_provider.dart';
import 'package:shapeshred/l10n/app_localizations.dart';

typedef FormFeedbackCallback = void Function(Map<String, dynamic> feedback);

/// Enhanced 3D Exercise Visualization Widget with premium materials and lighting
class PremiumExerciseVisualization3D extends StatefulWidget {
  final Exercise exercise;
  final bool showFormFeedback;
  final bool isCameraActive;
  final FormFeedbackCallback? onFormFeedback;
  final bool showEnvironment;

  const PremiumExerciseVisualization3D({
    super.key,
    required this.exercise,
    this.showFormFeedback = false,
    required this.isCameraActive,
    this.onFormFeedback,
    this.showEnvironment = true,
  });

  @override
  State<PremiumExerciseVisualization3D> createState() =>
      _PremiumExerciseVisualization3DState();
}

class _PremiumExerciseVisualization3DState extends State<PremiumExerciseVisualization3D>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _pulseAnimation;
  Map<String, dynamic>? _latestFormFeedback;
  double _environmentIntensity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppCurves.premiumFluid,
      ),
    );

    // Simulate environment interaction
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _environmentIntensity = 0.3 + (math.Random().nextDouble() * 0.4);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    // Determine if we should show 3D visualization or placeholder
    final bool show3D = widget.exercise.thumbnailUrl != null ||
        widget.exercise.videoUrl != null;

    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Environment effects
          if (widget.showEnvironment)
            Positioned.fill(
              child: CustomPaint(
                painter: _EnvironmentPainter(
                  intensity: _environmentIntensity,
                  time: _controller.value,
                ),
              ),
            ),

          // 3D Model Placeholder (would be replaced with actual 3D viewer)
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.rotate(
                angle: _rotationAnimation.value,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: _buildExerciseModel(),
                ),
              ),
            ),
          ),

          // FormTracker Overlay (when camera is active)
          if (widget.isCameraActive)
            const FormTrackerOverlay(),

          // Form Feedback Overlay
          if (widget.showFormFeedback && widget.isCameraActive)
            _buildFormFeedbackOverlay(),

          // Camera Active Indicator
          if (widget.isCameraActive)
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
      width: 200.w,
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.secondary.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
          SizedBox(height: 4.h),
          Text(
            '${widget.exercise.muscleGroup}',
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFeedbackOverlay() {
    if (_latestFormFeedback == null) {
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

    final double overallScore = (_latestFormFeedback!['depth'] as double) * 0.3 +
        (_latestFormFeedback!['speed'] as double) * 0.2 +
        (_latestFormFeedback!['alignment'] as double) * 0.3 +
        (_latestFormFeedback!['stability'] as double) * 0.2;

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
              AppColors.scrim.withValues(alpha: 0.6),
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
                _buildFormMetric(
                    'Depth', _latestFormFeedback!['depth'] as double),
                _buildFormMetric(
                    'Speed', _latestFormFeedback!['speed'] as double),
                _buildFormMetric(
                    'Alignment', _latestFormFeedback!['alignment'] as double),
                _buildFormMetric(
                    'Stability', _latestFormFeedback!['stability'] as double),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              width: 220.w,
              height: 10.h,
              decoration: BoxDecoration(
                border: Border.all(color: scoreColor),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Container(
                width: (220.w * overallScore).clamp(0.0, 220.w),
                height: 10.h,
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
          width: 22.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2.5.r),
          ),
        ),
      ],
    );
  }
}

// Environment painter for background effects
class _EnvironmentPainter extends CustomPainter {
  final double intensity;
  final double time;

  _EnvironmentPainter({
    required this.intensity,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05 * intensity)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    final random = math.Random(42); // Fixed seed for consistent animation
    for (int i = 0; i < 20; i++) {
      final double x = (math.sin(time + i * 0.3) * 0.5 + 0.5) * size.width;
      final double y = (math.cos(time * 0.5 + i * 0.7) * 0.5 + 0.5) * size.height;
      final double particleSize = 2 + (math.sin(time * 0.3 + i) * 0.5 + 0.5) * 3;

      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint..color = AppColors.primary.withValues(alpha: 0.03 * intensity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnvironmentPainter oldDelegate) =>
      oldDelegate.intensity != intensity || oldDelegate.time != time;
}

/// Super Ultra Premium Workout Player Page
class SuperUltraPremiumWorkoutPage extends ConsumerStatefulWidget {
  const SuperUltraPremiumWorkoutPage({super.key});

  @override
  ConsumerState<SuperUltraPremiumWorkoutPage> createState() =>
      _SuperUltraPremiumWorkoutPageState();
}

class _SuperUltraPremiumWorkoutPageState
    extends ConsumerState<SuperUltraPremiumWorkoutPage>
    with TickerProviderStateMixin {
  late final WorkoutBiometricsMonitor _biometrics;
  final Map<String, double> _formScores = {};
  bool _showFormFeedback = false;
  bool _isCameraActive = false;
  String _lastHrZone = 'warmup';
  late final AnimationController _breathingController;
  late final Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _biometrics = WorkoutBiometricsMonitor(0.5);
    _biometrics.addListener(_onBiometricChange);
    _enableFormAnalysis();

    // Breathing animation for guided respiration
    _breathingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _biometrics.removeListener(_onBiometricChange);
    _biometrics.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  void _onBiometricChange() {
    // Provide haptic feedback based on biometric changes
    final int hr = _biometrics.estimatedHeartRate;

    // Heart rate zone-based haptic feedback
    if (hr >= 160 && _lastHrZone != 'peak') {
      HapticHelper.heartRateZoneEntered('peak');
      _lastHrZone = 'peak';
    }
    else if (hr >= 140 && hr < 160 && _lastHrZone != 'cardio') {
      HapticHelper.heartRateZoneEntered('cardio');
      _lastHrZone = 'cardio';
    }
    else if (hr >= 120 && hr < 140 && _lastHrZone != 'fatburn') {
      HapticHelper.heartRateZoneEntered('fatburn');
      _lastHrZone = 'fatburn';
    }
    else if (hr < 120 && _lastHrZone != 'warmup') {
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
      _formScores[DateTime.now().toIso8601String()] =
          ((feedback['depth'] as double) * 0.3 +
              (feedback['speed'] as double) * 0.2 +
              (feedback['alignment'] as double) * 0.3 +
              (feedback['stability'] as double) * 0.2);

      // Keep only last 10 scores
      if (_formScores.length > 10) {
        final keys = _formScores.keys.toList()..sort();
        _formScores.remove(keys.first);
      }

      // Calculate average form score for this exercise
      final double avgScore =
          _formScores.values.reduce((a, b) => a + b) / _formScores.length;
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

    // If no workout is selected or it has no exercises, go back.
    if (state.workout == null ||
        (!state.isFinished && state.currentExercise == null)) {
      Future.microtask(() => Navigator.of(context).maybePop());
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isFinished) {
      return _buildFinishedScreen(context, state);
    }

    // Main workout UI with premium enhancements
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
                // Biometric Header with breathing guidance
                _buildBiometricHeader(),
                SizedBox(height: AppSpacing.space16.h),

                // Progress Indicator with Biometric Color and breathing effect
                _buildProgressIndicator(state),
                SizedBox(height: AppSpacing.space16.h),

                // Exercise Info with animated transition
                _buildExerciseInfo(state.currentExercise!.exercise),
                SizedBox(height: AppSpacing.space24.h),

                // Premium 3D Exercise Visualization
                PremiumExerciseVisualization3D(
                  exercise: state.currentExercise!.exercise,
                  showFormFeedback: _showFormFeedback,
                  isCameraActive: _isCameraActive,
                  onFormFeedback: _onFormFeedback,
                  showEnvironment: true,
                ),
                SizedBox(height: AppSpacing.space24.h),

                // Set Counter with premium styling
                _buildSetCounter(state),
                SizedBox(height: AppSpacing.space24.h),

                // Rep Counter with haptic feedback
                _buildRepCounter(state),
                SizedBox(height: AppSpacing.space24.h),

                // Weight Input with premium styling
                _buildWeightInput(),
                SizedBox(height: AppSpacing.space24.h),

                // RPE Slider with visual feedback
                _buildRPESlider(),
                SizedBox(height: AppSpacing.space32.h),

                // Form Tips with camera toggle
                _buildFormTips(),
                SizedBox(height: AppSpacing.space32.h),

                // Complete Set Button with premium animation
                PremiumButton(
                  label: 'Complete Set',
                  onPressed: () {
                    ref.read(workoutSessionProvider.notifier).completeSet();
                    HapticHelper.lightImpact();
                  },
                  fullWidth: true,
                ),
                SizedBox(height: AppSpacing.space16.h),

                // Skip Button with premium styling
                OutlinedButton(
                  onPressed: () {
                    ref.read(workoutSessionProvider.notifier).skipExercise();
                    HapticHelper.lightImpact();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.outline),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusMedium),
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
              child: PremiumCard(
                padding: EdgeInsets.all(AppSpacing.cardPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workout Intensity',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppTextColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(value * 100).toStringAsFixed(0)}%',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getIntensityColor(value),
                          ),
                        ),
                        Text(
                          'HR: ${_biometrics.estimatedHeartRate}bpm',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppTextColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            PremiumCard(
              padding: EdgeInsets.all(AppSpacing.cardPadding.w),
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      _getIntensityColor(value).withValues(alpha: 0.2),
                      _getIntensityColor(value).withValues(alpha: 0.05),
                    ],
                    center: Alignment.center,
                    radius: 0.7,
                  ),
                  border: Border.all(
                    color: _getIntensityColor(value).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.radiusCircle),
                ),
                child: Center(
                  child: Text(
                    '${_biometrics.estimatedHeartRate}',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getIntensityColor(value),
                    ),
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
    final double progress =
        (state.exerciseIndex + state.setIndex / state.currentExercise!.sets) /
            state.workout!.exercises.length;

    return PremiumCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 10.h,
        child: Stack(
          children: [
            // Background track
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            // Progress bar with biometric color and breathing effect
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
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [
                        BoxShadow(
                          color: _getIntensityColor(value).withValues(alpha: 0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(Exercise exercise) {
    return PremiumCard(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
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
      ),
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
    return PremiumCard(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Set ${state.setIndex} of ${state.currentExercise!.sets}',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: _biometrics.value > 0.7
                  ? AppColors.error
                  : AppColors.primary,
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
    return PremiumCard(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
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
                    HapticHelper.lightImpact();
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
                    HapticHelper.lightImpact();
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

  Widget _buildRepButton(
      {required IconData icon, required VoidCallback onTap}) {
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
    return PremiumCard(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight (kg) - Optional',
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter weight',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppTextColors.tertiary,
              ),
              suffixText: 'kg',
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.inputPaddingVertical,
              ),
            ),
            onChanged: (value) {
              // We don't need to store this locally; the notifier doesn't use weight.
              // If we wanted to persist weight, we'd need to extend the workout log.
              // For now, we ignore it.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRPESlider() {
    return PremiumCard(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate of Perceived Exertion (RPE)',
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
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
                    HapticHelper.lightImpact();
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
      ),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
                AnimatedBuilder(
                  animation: _breathingAnimation,
                  builder: (context, child) => IconButton(
                    icon: Icon(
                      Icons.videocam,
                      size: 20.sp,
                      color: _isCameraActive
                          ? AppColors.success
                          : AppColors.onPrimary.withValues(alpha: 0.7),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration animation with particle effects
              AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.elasticOut,
                width: 140.w,
                height: 140.h,
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
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 15,
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
                AppLocalizations.of(context)!.workoutComplete,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                state.workout?.name ?? 'Workout',
                style: AppTypography.titleLarge.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              _buildFinishedStat(
                icon: Icons.access_time,
                label: AppLocalizations.of(context)!.duration,
                value: '${state.elapsed.inMinutes} min',
              ),
              SizedBox(height: AppSpacing.space12.h),
              _buildFinishedStat(
                icon: Icons.local_fire_department,
                label: AppLocalizations.of(context)!.caloriesBurned,
                value:
                    '${(6.0 * 70.0 * state.elapsed.inSeconds / 3600).round()} cal',
              ),
              SizedBox(height: AppSpacing.space12.h),
              _buildFinishedStat(
                icon: Icons.fitness_center,
                label: 'Exercises',
                value: '${state.workout?.exercises.length ?? 0}',
              ),
              SizedBox(height: AppSpacing.space32.h),

              PremiumButton(
                label: AppLocalizations.of(context)!.finishWorkout,
                onPressed: () {
                  HapticHelper.successImpact();
                  // Reset the selection so the session doesn't get reused.
                  ref.read(selectedWorkoutProvider.notifier).select(null);
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

  Widget _buildFinishedStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28.sp, color: AppTextColors.secondary),
          SizedBox(width: AppSpacing.space16.w),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTextColors.secondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Biometrics monitor for workout intensity and heart rate simulation
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