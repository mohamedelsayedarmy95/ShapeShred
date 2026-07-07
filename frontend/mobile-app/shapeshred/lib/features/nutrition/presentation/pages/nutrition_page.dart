import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/calories_hero_card.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/macro_breakdown.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/meal_list_item.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/water_tracker.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
                vertical: AppSpacing.space16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutrition',
                    style: AppTypography.headlineLarge,
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  Text(
                    'Track your daily intake',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calories Hero Card
                    const CaloriesHeroCard(
                      consumed: 1450,
                      goal: 2200,
                    ),
                    SizedBox(height: AppSpacing.space24.h),

                    // Macro Breakdown
                    const MacroBreakdown(
                      protein: 95,
                      proteinGoal: 150,
                      carbs: 180,
                      carbsGoal: 250,
                      fat: 55,
                      fatGoal: 70,
                    ),
                    SizedBox(height: AppSpacing.space32.h),

                    // Section Title: Meals
                    Text(
                      'Today\'s Meals',
                      style: AppTypography.headlineSmall,
                    ),
                    SizedBox(height: AppSpacing.space16.h),

                    // Meals List
                    const MealListItem(
                      mealType: 'Breakfast',
                      time: '8:30 AM',
                      calories: 450,
                      items: 'Oatmeal, Berries, Almonds',
                      icon: Icons.wb_sunny_outlined,
                    ),
                    SizedBox(height: AppSpacing.space12.h),
                    const MealListItem(
                      mealType: 'Lunch',
                      time: '1:00 PM',
                      calories: 650,
                      items: 'Grilled Chicken, Quinoa, Vegetables',
                      icon: Icons.restaurant,
                    ),
                    SizedBox(height: AppSpacing.space12.h),
                    const MealListItem(
                      mealType: 'Snack',
                      time: '4:30 PM',
                      calories: 200,
                      items: 'Protein Shake, Banana',
                      icon: Icons.coffee,
                    ),
                    SizedBox(height: AppSpacing.space12.h),
                    const MealListItem(
                      mealType: 'Dinner',
                      time: 'Not yet',
                      calories: 0,
                      items: 'Tap to add meal',
                      icon: Icons.nights_stay_outlined,
                      isEmpty: true,
                    ),
                    SizedBox(height: AppSpacing.space32.h),

                    // Water Tracker
                    const WaterTracker(
                      current: 5,
                      goal: 8,
                    ),
                    SizedBox(height: AppSpacing.space32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColorPalette.absoluteBlack,
        icon: const Icon(Icons.add, color: AppColorPalette.pureWhite),
        label: Text(
          'Add Meal',
          style: AppTypography.labelLarge.copyWith(
            color: AppColorPalette.pureWhite,
          ),
        ),
      ),
    );
  }
}
