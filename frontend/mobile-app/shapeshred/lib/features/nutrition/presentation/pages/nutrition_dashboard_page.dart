import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/press_feedback.dart';
import '../bloc/nutrition_bloc.dart';

class NutritionDashboardPage extends StatelessWidget {
  const NutritionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<NutritionBloc>()..add(LoadActivePlan()),
      child: Scaffold(
        backgroundColor: AppSurfaceLevel.background,
        appBar: AppBar(
          title: const Text('Nutrition'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.go('/meal-logger'),
            ),
          ],
        ),
        body: BlocBuilder<NutritionBloc, NutritionState>(
          builder: (context, state) {
            if (state is NutritionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NutritionLoaded) {
              return _buildContent(context, state);
            } else if (state is NutritionError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NutritionLoaded state) {
    final plan = state.plan;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.space16.h),
          // Daily Macro Summary Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space20.w),
            decoration: BoxDecoration(
              color: AppColorPalette.gray900,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMacroStat('Calories', '1,200',
                        plan.dailyCalories.toInt().toString()),
                    _buildMacroStat(
                        'Protein', '95g', '${plan.dailyProteinG.toInt()}g'),
                    _buildMacroStat(
                        'Carbs', '110g', '${plan.dailyCarbsG.toInt()}g'),
                    _buildMacroStat('Fat', '40g', '${plan.dailyFatG.toInt()}g'),
                  ],
                ),
                SizedBox(height: AppSpacing.space16.h),
                LinearProgressIndicator(
                  value: 1200 / plan.dailyCalories,
                  backgroundColor: AppColorPalette.gray700,
                  color: AppColorPalette.pureWhite,
                  minHeight: 6.h,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.space32.h),
          Text(
            'Today\'s Meals',
            style: AppTypography.textTheme.headlineSmall,
          ),
          SizedBox(height: AppSpacing.space12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plan.meals.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.space12.h),
            itemBuilder: (context, index) {
              final meal = plan.meals[index];
              return _buildMealCard(meal);
            },
          ),
          SizedBox(height: AppSpacing.space32.h),
          _buildWaterTracker(),
          SizedBox(height: AppSpacing.space32.h),
        ],
      ),
    );
  }

  Widget _buildMealCard(dynamic meal) {
    return PressFeedback(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColorPalette.gray200, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColorPalette.gray200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child:
                  const Icon(Icons.restaurant, color: AppColorPalette.gray900),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name as String,
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${meal.mealType} • ${meal.calories.toInt()} kcal',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColorPalette.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterTracker() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppSurfaceLevel.elevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorPalette.gray200, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop,
              color: AppColorPalette.gray900, size: 28),
          SizedBox(width: AppSpacing.space16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Intake',
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: AppColorPalette.gray200,
                  color: AppColorPalette.gray900,
                  minHeight: 4.h,
                ),
                SizedBox(height: 4.h),
                Text(
                  '1.8L / 3.0L',
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: AppTextColor.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, String current, String target) {
    return Column(
      children: [
        Text(
          current,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: AppColorPalette.pureWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '/ $target',
          style: AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColorPalette.gray400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColorPalette.gray300,
          ),
        ),
      ],
    );
  }
}
