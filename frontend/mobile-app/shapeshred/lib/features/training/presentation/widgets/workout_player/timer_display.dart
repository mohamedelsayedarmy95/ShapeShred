import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class TimerDisplay extends StatelessWidget {
  final int currentTime;
  final int targetTime;
  final bool isResting;

  const TimerDisplay({
    super.key,
    required this.currentTime,
    required this.targetTime,
    required this.isResting,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _formatTime(currentTime),
          style: AppTypography.displayLarge.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            color: isResting ? AppColorPalette.gray500 : AppColorPalette.gray900,
          ),
        ),
        SizedBox(height: AppSpacing.space8.h),
        Text(
          'of ${_formatTime(targetTime)}',
          style: AppTypography.bodyLarge.copyWith(
            color: AppTextColor.secondary,
          ),
        ),
      ],
    );
  }
}
