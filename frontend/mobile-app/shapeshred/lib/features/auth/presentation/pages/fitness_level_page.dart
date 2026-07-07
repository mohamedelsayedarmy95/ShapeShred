import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/pages/login_page.dart';

class FitnessLevelPage extends StatefulWidget {
  const FitnessLevelPage({super.key});

  @override
  State<FitnessLevelPage> createState() => _FitnessLevelPageState();
}

class _FitnessLevelPageState extends State<FitnessLevelPage> {
  String? _selectedLevel;

  final List<Map<String, dynamic>> _levels = [
    {
      'id': 'beginner',
      'title': 'Beginner',
      'subtitle': 'New to working out',
      'icon': Icons.emoji_people,
      'description': 'Just starting your fitness journey',
    },
    {
      'id': 'intermediate',
      'title': 'Intermediate',
      'subtitle': 'Some experience',
      'icon': Icons.directions_run,
      'description': 'Work out 2-3 times per week',
    },
    {
      'id': 'advanced',
      'title': 'Advanced',
      'subtitle': 'Regular athlete',
      'icon': Icons.fitness_center,
      'description': 'Work out 4+ times per week',
    },
    {
      'id': 'elite',
      'title': 'Elite',
      'subtitle': 'Professional level',
      'icon': Icons.emoji_events,
      'description': 'Competitive athlete or trainer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Your fitness level',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'We\'ll adjust the intensity accordingly',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space32.h),

              // Level Options
              Expanded(
                child: ListView.separated(
                  itemCount: _levels.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppSpacing.space12.h),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> level = _levels[index];
                    final isSelected = _selectedLevel == level['id'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLevel = level['id'] as String?;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.space20.w),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColorPalette.gray900 
                              : AppColorPalette.gray50,
                          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                          border: Border.all(
                            color: isSelected 
                                ? AppColorPalette.gray900 
                                : AppColorPalette.gray200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColorPalette.gray800 
                                    : AppColorPalette.pureWhite,
                                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                              ),
                              child: Icon(
                                level['icon'] as IconData,
                                color: isSelected 
                                    ? AppColorPalette.pureWhite 
                                    : AppColorPalette.gray900,
                                size: 28.sp,
                              ),
                            ),
                            SizedBox(width: AppSpacing.space16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level['title'] as String,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: isSelected 
                                          ? AppColorPalette.pureWhite 
                                          : AppColorPalette.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.space4.h),
                                  Text(
                                    level['description'] as String,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isSelected 
                                          ? AppColorPalette.gray300 
                                          : AppTextColor.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColorPalette.pureWhite,
                                size: 24.sp,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Button
              GestureDetector(
                onTap: _selectedLevel != null
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    color: _selectedLevel != null 
                        ? AppColorPalette.gray900 
                        : AppColorPalette.gray200,
                    borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUE',
                        style: AppTypography.labelLarge.copyWith(
                          color: _selectedLevel != null 
                              ? AppColorPalette.pureWhite 
                              : AppColorPalette.gray400,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Icon(
                        Icons.arrow_forward,
                        color: _selectedLevel != null 
                            ? AppColorPalette.pureWhite 
                            : AppColorPalette.gray400,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

