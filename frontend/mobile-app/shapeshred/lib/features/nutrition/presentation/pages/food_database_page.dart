import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_text_field.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/nutrition/domain/models/food.dart';
import 'package:shapeshred/features/nutrition/domain/repositories/food_repository.dart';

class FoodDatabasePage extends StatefulWidget {
  final Function(Food, double)? onFoodSelected;

  const FoodDatabasePage({
    super.key,
    this.onFoodSelected,
  });

  @override
  State<FoodDatabasePage> createState() => _FoodDatabasePageState();
}

class _FoodDatabasePageState extends State<FoodDatabasePage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Food> get _filteredFoods {
    var foods = FoodRepository.foods;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      foods = FoodRepository.search(_searchController.text);
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      foods = foods.where((f) => f.category == _selectedCategory).toList();
    }

    return foods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorPalette.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Food Database',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: PremiumTextField(
                label: '',
                hint: 'Search foods...',
                controller: _searchController,
                prefixIcon: Icons.search,
                onChanged: (value) => setState(() {}),
              ),
            ),

            // Category Filters
            _buildCategoryFilters(),

            // Food List
            Expanded(
              child: _filteredFoods.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
                      itemCount: _filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = _filteredFoods[index];
                        return _buildFoodCard(food);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ['All', ...FoodRepository.categories].length,
        itemBuilder: (context, index) {
          final category = index == 0 ? 'All' : FoodRepository.categories[index - 1];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.space8.w),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                HapticHelper.light();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16.w,
                  vertical: AppSpacing.space12.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  border: Border.all(
                    color: isSelected ? AppColorPalette.gray900 : AppColorPalette.gray200,
                  ),
                ),
                child: Text(
                  category,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? AppColorPalette.pureWhite : AppColorPalette.gray900,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(Food food) {
    return GestureDetector(
      onTap: () {
        HapticHelper.light();
        _showFoodDetails(food);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColorPalette.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColorPalette.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    food.name,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space8.w,
                    vertical: AppSpacing.space4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorPalette.gray100,
                    borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                  ),
                  child: Text(
                    food.category,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColorPalette.gray700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.space4.h),
            Text(
              food.brand,
              style: AppTypography.bodySmall.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),

            // Macros Grid
            Row(
              children: [
                _buildMacroItem(
                  label: 'Calories',
                  value: '${food.calories}',
                  color: AppColorPalette.gray900,
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildMacroItem(
                  label: 'Protein',
                  value: '${food.protein}g',
                  color: AppColorPalette.success,
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildMacroItem(
                  label: 'Carbs',
                  value: '${food.carbs}g',
                  color: AppColorPalette.warning,
                ),
                SizedBox(width: AppSpacing.space16.w),
                _buildMacroItem(
                  label: 'Fat',
                  value: '${food.fat}g',
                  color: AppColorPalette.error,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              'Serving: ${food.servingSize}${food.servingUnit}',
              style: AppTypography.labelSmall.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem({required String label, required String value, required Color color}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: AppSpacing.space4.h),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppTextColor.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 64.sp,
            color: AppColorPalette.gray300,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'No foods found',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColor.secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFoodDetails(Food food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColorPalette.pureWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.radiusXL),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(AppSpacing.screenPadding.w),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
                  decoration: BoxDecoration(
                    color: AppColorPalette.gray200,
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  ),
                ),
              ),

              // Food Name
              Text(
                food.name,
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                food.brand,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Serving Info
              Container(
                padding: EdgeInsets.all(AppSpacing.space16.w),
                decoration: BoxDecoration(
                  color: AppColorPalette.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Serving Size',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      '${food.servingSize}${food.servingUnit}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Macros
              Text(
                'Nutrition per Serving',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),
              _buildMacroRow('Calories', '${food.calories}', AppColorPalette.gray900),
              _buildMacroRow('Protein', '${food.protein}g', AppColorPalette.success),
              _buildMacroRow('Carbohydrates', '${food.carbs}g', AppColorPalette.warning),
              _buildMacroRow('Fat', '${food.fat}g', AppColorPalette.error),
              _buildMacroRow('Fiber', '${food.fiber}g', AppColorPalette.gray700),
              _buildMacroRow('Sugar', '${food.sugar}g', AppColorPalette.gray700),
              SizedBox(height: AppSpacing.space24.h),

              // Quantity Input
              Text(
                'Quantity (grams)',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColorPalette.gray50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  border: Border.all(color: AppColorPalette.gray200),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '${food.servingSize}',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColorPalette.gray400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.inputPaddingHorizontal,
                      vertical: AppSpacing.inputPaddingVertical,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Add Button
              ElevatedButton(
                onPressed: () {
                  HapticHelper.success();
                  Navigator.pop(context);
                  if (widget.onFoodSelected != null) {
                    widget.onFoodSelected!(food, food.servingSize.toDouble());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorPalette.gray900,
                  foregroundColor: AppColorPalette.pureWhite,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
                child: Text(
                  'Add to Meal',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space12.h),
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
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
