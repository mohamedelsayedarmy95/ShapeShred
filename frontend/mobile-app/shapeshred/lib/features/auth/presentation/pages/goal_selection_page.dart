import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/auth/presentation/pages/body_metrics_page.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  String? _selectedGoal;

  final List<Map<String, dynamic>> _goals = [
    {
      'id': 'lose_weight',
      'title': 'Lose Weight',
      'subtitle': 'Burn fat and get lean',
      'icon': Icons.trending_down,
    },
    {
      'id': 'build_muscle',
      'title': 'Build Muscle',
      'subtitle': 'Gain strength and size',
      'icon': Icons.fitness_center,
    },
    {
      'id': 'maintain',
      'title': 'Stay Fit',
      'subtitle': 'Maintain current physique',
      'icon': Icons.favorite,
    },
    {
      'id': 'improve_endurance',
      'title': 'Improve Endurance',
      'subtitle': 'Boost stamina and cardio',
      'icon': Icons.directions_run,
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
                'What\'s your goal?',
                style: AppTypography.headlineLarge,
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                'We\'ll personalize your experience',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space32.h),

              // Goal Options
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppSpacing.space12.h),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoal == goal['id'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGoal = goal['id'];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.space20.w),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColorPalette.gray900 
                              : AppColorPalette.gray50,
                          borderRadius: BorderRadius.circular(AppRadius.l),
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
                                borderRadius: BorderRadius.circular(AppRadius.m),
                              ),
                              child: Icon(
                                goal['icon'] as IconData,
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
                                    goal['title'] as String,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: isSelected 
                                          ? AppColorPalette.pureWhite 
                                          : AppColorPalette.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.space4.h),
                                  Text(
                                    goal['subtitle'] as String,
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
                onTap: _selectedGoal != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BodyMetricsPage(),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    color: _selectedGoal != null 
                        ? AppColorPalette.gray900 
                        : AppColorPalette.gray200,
                    borderRadius: BorderRadius.circular(AppRadius.l),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUE',
                        style: AppTypography.labelLarge.copyWith(
                          color: _selectedGoal != null 
                              ? AppColorPalette.pureWhite 
                              : AppColorPalette.gray400,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: AppSpacing.space8.w),
                      Icon(
                        Icons.arrow_forward,
                        color: _selectedGoal != null 
                            ? AppColorPalette.pureWhite 
                            : AppColorPalette.gray400,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),
            ],
          ),
        ),
      ),
    );
  }
}
