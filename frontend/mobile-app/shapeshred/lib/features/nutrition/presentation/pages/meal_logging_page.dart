import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/nutrition/domain/models/food.dart';
import 'package:shapeshred/features/nutrition/domain/models/food.dart' as food_models;
import 'package:shapeshred/features/nutrition/presentation/pages/food_database_page.dart';

class MealLoggingPage extends StatefulWidget {
  const MealLoggingPage({super.key});

  @override
  State<MealLoggingPage> createState() => _MealLoggingPageState();
}

class _MealLoggingPageState extends State<MealLoggingPage> {
  String _selectedMealType = 'Breakfast';
  final List<food_models.MealItem> _mealItems = [];
  bool _isLoading = false;

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  int get _totalCalories => _mealItems.fold(0, (sum, item) => sum + item.calories);
  double get _totalProtein => _mealItems.fold(0.0, (sum, item) => sum + item.protein);
  double get _totalCarbs => _mealItems.fold(0.0, (sum, item) => sum + item.carbs);
  double get _totalFat => _mealItems.fold(0.0, (sum, item) => sum + item.fat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTextColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Log Meal',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.space16.h),

              // Meal Type Selection
              Text(
                'Meal Type',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Wrap(
                spacing: AppSpacing.space8.w,
                runSpacing: AppSpacing.space8.h,
                children: _mealTypes.map((type) {
                  final isSelected = _selectedMealType == type;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedMealType = type);
                      HapticHelper.light();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space16.w,
                        vertical: AppSpacing.space12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outline,
                        ),
                      ),
                      child: Text(
                        type,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppTextColors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Add Food Button
              OutlinedButton.icon(
                onPressed: () {
                  HapticHelper.light();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDatabasePage(
                        onFoodSelected: (food, quantity) {
                          setState(() {
                            _mealItems.add(food_models.MealItem.fromFood(food, quantity));
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add, color: AppColors.primary),
                label: Text(
                  'Add Food',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Meal Items
              if (_mealItems.isEmpty)
                Container(
                  padding: EdgeInsets.all(AppSpacing.space24.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 48.sp,
                          color: AppTextColors.tertiary,
                        ),
                        SizedBox(height: AppSpacing.space16.h),
                        Text(
                          'No foods added yet',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppTextColors.secondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.space8.h),
                        Text(
                          'Tap the button above to add foods',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTextColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._mealItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildMealItemCard(item, index);
                }).toList(),
              SizedBox(height: AppSpacing.space24.h),

              // Summary
              if (_mealItems.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(AppSpacing.space16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Calories', '$_totalCalories', AppTextColors.primary),
                      _buildSummaryRow('Protein', '${_totalProtein.toStringAsFixed(1)}g', AppColors.success),
                      _buildSummaryRow('Carbs', '${_totalCarbs.toStringAsFixed(1)}g', AppColors.warning),
                      _buildSummaryRow('Fat', '${_totalFat.toStringAsFixed(1)}g', AppColors.error),
                    ],
                  ),
                ),
              SizedBox(height: AppSpacing.space32.h),

              // Save Button
              PremiumButton(
                label: 'Save Meal',
                onPressed: _mealItems.isEmpty ? null : _saveMeal,
                isLoading: _isLoading,
                fullWidth: true,
              ),
              SizedBox(height: AppSpacing.space16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealItemCard(food_models.MealItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.space12.h),
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  '${item.quantity}g • ${item.calories} cal',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              HapticHelper.light();
              setState(() => _mealItems.removeAt(index));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.space8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMeal() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final meal = food_models.Meal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedMealType.toLowerCase(),
        date: DateTime.now(),
        items: _mealItems,
        totalCalories: _totalCalories,
        totalProtein: _totalProtein,
        totalCarbs: _totalCarbs,
        totalFat: _totalFat,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('meals')
          .doc(meal.id)
          .set(meal.toJson());

      if (mounted) {
        HapticHelper.successImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Meal saved successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save meal: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
