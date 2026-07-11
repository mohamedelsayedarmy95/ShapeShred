import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/features/training/domain/models/workout.dart';

class ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;
  final bool isResting;

  const ExerciseDisplay({
    super.key,
    required this.exercise,
    required this.isResting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BreathingIconCircle(
          isResting: isResting,
          icon: isResting ? Icons.pause_circle_filled : exercise.icon,
        ),
        SizedBox(height: AppSpacing.space32.h),

        // Exercise Name
        Text(
          isResting ? 'REST' : exercise.name,
          style: AppTypography.headlineLarge.copyWith(
            color: isResting ? AppTextColors.secondary : AppTextColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.space8.h),

        // Description
        Text(
          isResting ? 'Take a breather' : exercise.description,
          style: AppTypography.bodyLarge.copyWith(
            color: AppTextColors.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Icon circle with a slow, subtle breathing pulse to signal the player is live.
class _BreathingIconCircle extends StatefulWidget {
  final bool isResting;
  final IconData icon;

  const _BreathingIconCircle({required this.isResting, required this.icon});

  @override
  State<_BreathingIconCircle> createState() => _BreathingIconCircleState();
}

class _BreathingIconCircleState extends State<_BreathingIconCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.epic,
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.premiumFluid),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isResting ? AppColors.secondary : AppColors.primary;
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: AnimatedSwitcher(
        duration: AppDurations.substantial,
        switchInCurve: AppCurves.premiumFluid,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Container(
          key: ValueKey('${widget.isResting}-${widget.icon.codePoint}'),
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isResting
                  ? [
                      AppColors.secondary,
                      AppColors.secondary.withValues(alpha: 0.7)
                    ]
                  : AppColors.heroGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color:
                widget.isResting ? AppColors.onSecondary : AppColors.onPrimary,
            size: 60.sp,
          ),
        ),
      ),
    );
  }
}
