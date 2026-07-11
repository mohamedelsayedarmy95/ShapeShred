import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

class RestTimer extends StatefulWidget {
  final int duration; // in seconds
  final VoidCallback? onTimerComplete;
  final VoidCallback? onSkip;
  final bool autoStart;

  const RestTimer({
    super.key,
    required this.duration,
    this.onTimerComplete,
    this.onSkip,
    this.autoStart = true,
  });

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    if (widget.autoStart) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _controller.forward();
    HapticHelper.light();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);

        // Haptic feedback at specific intervals
        if (_remainingSeconds == 10) {
          HapticHelper.medium();
        } else if (_remainingSeconds == 5) {
          HapticHelper.medium();
        } else if (_remainingSeconds == 3) {
          HapticHelper.medium();
        } else if (_remainingSeconds == 2) {
          HapticHelper.light();
        } else if (_remainingSeconds == 1) {
          HapticHelper.light();
        }
      } else {
        _timer?.cancel();
        _isRunning = false;
        HapticHelper.successImpact();
        widget.onTimerComplete?.call();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _controller.stop();
    setState(() => _isRunning = false);
    HapticHelper.light();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _skipTimer() {
    _timer?.cancel();
    _controller.stop();
    HapticHelper.light();
    widget.onSkip?.call();
  }

  void _resetTimer() {
    _timer?.cancel();
    _controller.reset();
    setState(() {
      _remainingSeconds = widget.duration;
      _isRunning = false;
    });
    HapticHelper.light();
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer Circle
          SizedBox(
            width: 200.w,
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                // Progress Circle
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 200.w,
                      height: 200.h,
                      child: CircularProgressIndicator(
                        value: _animation.value,
                        strokeWidth: 8,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remainingSeconds <= 5
                              ? AppColors.error
                              : _remainingSeconds <= 10
                                  ? AppColors.warning
                                  : AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
                // Time Display
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formattedTime,
                      style: AppTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _remainingSeconds <= 5
                            ? AppColors.error
                            : _remainingSeconds <= 10
                                ? AppColors.warning
                                : AppTextColors.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8.h),
                    Text(
                      _isRunning ? 'Resting' : 'Paused',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppTextColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.space24.h),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRunning) ...[
                _buildControlButton(
                  icon: Icons.pause,
                  label: 'Pause',
                  onTap: _pauseTimer,
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildControlButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  onTap: _resetTimer,
                ),
              ] else ...[
                _buildControlButton(
                  icon: Icons.play_arrow,
                  label: 'Resume',
                  onTap: _resumeTimer,
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildControlButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  onTap: _resetTimer,
                ),
              ],
              SizedBox(width: AppSpacing.space16.w),
              _buildControlButton(
                icon: Icons.skip_next,
                label: 'Skip',
                onTap: _skipTimer,
                isSecondary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space12.h,
        ),
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.surfaceVariant : AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSecondary ? AppTextColors.primary : AppColors.onPrimary,
              size: 24.sp,
            ),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color:
                    isSecondary ? AppTextColors.primary : AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple rest timer dialog for quick use
class RestTimerDialog extends StatelessWidget {
  final int duration;
  final VoidCallback? onTimerComplete;
  final VoidCallback? onSkip;

  const RestTimerDialog({
    super.key,
    required this.duration,
    this.onTimerComplete,
    this.onSkip,
  });

  static Future<void> show(
    BuildContext context, {
    required int duration,
    VoidCallback? onTimerComplete,
    VoidCallback? onSkip,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: RestTimer(
          duration: duration,
          onTimerComplete: () {
            Navigator.pop(context);
            onTimerComplete?.call();
          },
          onSkip: () {
            Navigator.pop(context);
            onSkip?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
