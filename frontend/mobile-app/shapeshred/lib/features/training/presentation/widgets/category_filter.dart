import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.space8.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space20.w,
                vertical: AppSpacing.space12.h,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColorPalette.absoluteBlack 
                    : AppColorPalette.gray50,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected 
                      ? AppColorPalette.absoluteBlack 
                      : AppColorPalette.gray200,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTypography.labelLarge.copyWith(
                    color: isSelected 
                        ? AppColorPalette.pureWhite 
                        : AppColorPalette.gray700,
                    fontWeight: isSelected 
                        ? FontWeight.w600 
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
