import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/atoms/app_back_button.dart';

class WorkoutPlayerPage extends StatefulWidget {
  const WorkoutPlayerPage({super.key});

  @override
  State<WorkoutPlayerPage> createState() => _WorkoutPlayerPageState();
}

class _WorkoutPlayerPageState extends State<WorkoutPlayerPage> {
  int _currentExercise = 0;
  int _seconds = 0;
  bool _isPlaying = false;
  final List<String> exercises = [
    'Jumping Jacks',
    'Push-ups',
    'Squats',
    'Plank',
    'Lunges'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          '${_currentExercise + 1} / ${exercises.length}',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exercise placeholder
            Container(
              width: double.infinity,
              height: 250.h,
              decoration: BoxDecoration(
                color: AppSurfaceLevel.elevated,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColorPalette.gray200, width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center,
                        size: 80.sp, color: AppColorPalette.gray300),
                    SizedBox(height: 16.h),
                    Text(
                      exercises[_currentExercise],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            // Timer
            Text(
              _formatTime(_seconds),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(height: 32.h),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      size: 40, color: AppColorPalette.gray900),
                  onPressed: _isPlaying ? null : _prevExercise,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 72,
                    color: AppColorPalette.gray900,
                  ),
                  onPressed: _togglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      size: 40, color: AppColorPalette.gray900),
                  onPressed: _isPlaying ? null : _nextExercise,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Progress
            LinearProgressIndicator(
              value: (_currentExercise + 1) / exercises.length,
              backgroundColor: AppColorPalette.gray200,
              color: AppColorPalette.gray900,
              minHeight: 6.h,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Finish Workout'),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isPlaying && mounted) {
        setState(() => _seconds++);
        _startTimer();
      }
    });
  }

  void _nextExercise() {
    if (_currentExercise < exercises.length - 1) {
      setState(() {
        _currentExercise++;
        _seconds = 0;
      });
    }
  }

  void _prevExercise() {
    if (_currentExercise > 0) {
      setState(() {
        _currentExercise--;
        _seconds = 0;
      });
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
