import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/constants/app_colors.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.go('/training'),
        ),
        title: Text(
          '$_currentExercise + 1 / ${exercises.length}',
          style: const TextStyle(color: AppColors.black),
        ),
        centerTitle: true,
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
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.grey200, width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center,
                        size: 80.sp, color: AppColors.grey300),
                    SizedBox(height: 16.h),
                    Text(
                      exercises[_currentExercise],
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            // Timer
            Text(
              _formatTime(_seconds),
              style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black),
            ),
            SizedBox(height: 32.h),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      size: 40, color: AppColors.black),
                  onPressed: _isPlaying ? null : _prevExercise,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 72,
                    color: AppColors.black,
                  ),
                  onPressed: _togglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      size: 40, color: AppColors.black),
                  onPressed: _isPlaying ? null : _nextExercise,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Progress
            LinearProgressIndicator(
              value: (_currentExercise + 1) / exercises.length,
              backgroundColor: AppColors.grey200,
              color: AppColors.black,
              minHeight: 6.h,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => context.go('/training'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r)),
              ),
              child: Text('Finish Workout',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
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
