import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_text_field.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:shapeshred/features/training/domain/models/exercise.dart';
import 'package:shapeshred/features/training/domain/repositories/exercise_repository.dart';

class ExerciseLibraryPage extends StatefulWidget {
  const ExerciseLibraryPage({super.key});

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedMuscleGroup = 'All';
  String _selectedDifficulty = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> get _filteredExercises {
    var exercises = ExerciseRepository.exercises;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text.toLowerCase();
      exercises = exercises.where((e) =>
          e.name.toLowerCase().contains(search) ||
          e.description.toLowerCase().contains(search) ||
          e.muscleGroup.toLowerCase().contains(search)
      ).toList();
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      exercises = exercises.where((e) => e.category == _selectedCategory).toList();
    }

    // Filter by muscle group
    if (_selectedMuscleGroup != 'All') {
      exercises = exercises.where((e) => e.muscleGroup == _selectedMuscleGroup).toList();
    }

    // Filter by difficulty
    if (_selectedDifficulty != 'All') {
      exercises = exercises.where((e) => e.difficulty == _selectedDifficulty).toList();
    }

    return exercises;
  }

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
          'Exercise Library',
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
                hint: 'Search exercises...',
                controller: _searchController,
                prefixIcon: Icons.search,
                onChanged: (value) => setState(() {}),
              ),
            ),

            // Filters
            _buildFilters(),

            // Exercise List
            Expanded(
              child: _filteredExercises.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
                      itemCount: _filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = _filteredExercises[index];
                        return _buildExerciseCard(exercise);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          Text(
            'Category',
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ['All', ...ExerciseRepository.categories].length,
              itemBuilder: (context, index) {
                final category = index == 0 ? 'All' : ExerciseRepository.categories[index - 1];
                final isSelected = _selectedCategory == category;
                return _buildFilterChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedCategory = category);
                    HapticHelper.light();
                  },
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),

          // Muscle Group Filter
          Text(
            'Muscle Group',
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ['All', ...ExerciseRepository.muscleGroups].length,
              itemBuilder: (context, index) {
                final muscleGroup = index == 0 ? 'All' : ExerciseRepository.muscleGroups[index - 1];
                final isSelected = _selectedMuscleGroup == muscleGroup;
                return _buildFilterChip(
                  label: muscleGroup,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedMuscleGroup = muscleGroup);
                    HapticHelper.light();
                  },
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),

          // Difficulty Filter
          Text(
            'Difficulty',
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ['All', ...ExerciseRepository.difficulties].length,
              itemBuilder: (context, index) {
                final difficulty = index == 0 ? 'All' : ExerciseRepository.difficulties[index - 1];
                final isSelected = _selectedDifficulty == difficulty;
                return _buildFilterChip(
                  label: difficulty,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedDifficulty = difficulty);
                    HapticHelper.light();
                  },
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.space8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space16.w,
            vertical: AppSpacing.space8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.radiusPill),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outline,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.onPrimary : AppTextColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return GestureDetector(
      onTap: () {
        HapticHelper.light();
        _showExerciseDetails(exercise);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            // Exercise Icon/Thumbnail
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                _getExerciseIcon(exercise.muscleGroup),
                size: 32.sp,
                color: AppTextColors.secondary,
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),

            // Exercise Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    exercise.muscleGroup,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  Row(
                    children: [
                      _buildBadge(exercise.category),
                      SizedBox(width: AppSpacing.space8.w),
                      _buildBadge(exercise.difficulty),
                      SizedBox(width: AppSpacing.space8.w),
                      _buildBadge(exercise.equipment),
                    ],
                  ),
                ],
              ),
            ),

            // Duration
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space12.w,
                vertical: AppSpacing.space8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
              ),
              child: Text(
                '${exercise.duration}s',
                style: AppTypography.labelSmall.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space8.w,
        vertical: AppSpacing.space4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppTextColors.secondary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: AppTextColors.tertiary,
          ),
          SizedBox(height: AppSpacing.space16.h),
          Text(
            'No exercises found',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            'Try adjusting your filters',
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  ),
                ),
              ),

              // Exercise Name
              Text(
                exercise.name,
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Badges
              Row(
                children: [
                  _buildBadge(exercise.category),
                  SizedBox(width: AppSpacing.space8.w),
                  _buildBadge(exercise.difficulty),
                  SizedBox(width: AppSpacing.space8.w),
                  _buildBadge(exercise.equipment),
                ],
              ),
              SizedBox(height: AppSpacing.space16.h),

              // Description
              Text(
                'Description',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Text(
                exercise.description,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Instructions
              Text(
                'Instructions',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),
              ...exercise.instructions.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.space12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        margin: EdgeInsets.only(right: AppSpacing.space12.w),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.radiusSmall),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: AppSpacing.space24.h),

              // Add to Workout Button
              ElevatedButton(
                onPressed: () {
                  HapticHelper.light();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${exercise.name} added to workout',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onTertiary,
                        ),
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  ),
                ),
                child: Text(
                  'Add to Workout',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.onPrimary,
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

  IconData _getExerciseIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return Icons.fitness_center;
      case 'Back':
        return Icons.accessibility_new;
      case 'Legs':
        return Icons.directions_run;
      case 'Shoulders':
        return Icons.airline_seat_recline_extra;
      case 'Arms':
        return Icons.back_hand;
      case 'Core':
        return Icons.accessibility;
      case 'Full Body':
        return Icons.sports_gymnastics;
      default:
        return Icons.fitness_center;
    }
  }
}
