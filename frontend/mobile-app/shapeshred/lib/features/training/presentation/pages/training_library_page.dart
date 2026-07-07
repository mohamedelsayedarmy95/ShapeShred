import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/atoms/press_feedback.dart';
import 'package:shapeshred/core/design_system/atoms/app_back_button.dart';
import '../bloc/training_bloc.dart';

class TrainingLibraryPage extends StatelessWidget {
  const TrainingLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TrainingBloc>()..add(LoadExercises()),
      child: Scaffold(
        backgroundColor: AppSurfaceLevel.background,
        appBar: AppBar(
          title: const Text('Training'),
          leading: const AppBackButton(),
        ),
        body: BlocBuilder<TrainingBloc, TrainingState>(
          builder: (context, state) {
            if (state is TrainingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TrainingLoaded) {
              return _buildContent(context, state);
            } else if (state is TrainingError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TrainingLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Exercise Library',
              style: AppTypography.textTheme.headlineSmall,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.space12.w,
              mainAxisSpacing: AppSpacing.space12.h,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final exercise = state.exercises[index];
                return _buildExerciseCard(exercise);
              },
              childCount: state.exercises.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(dynamic exercise) {
    return PressFeedback(
      onTap: () {
        // TODO: Navigate to Exercise Details
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColorPalette.gray200, width: 1),
        ),
        padding: EdgeInsets.all(AppSpacing.space12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.space8.w),
              decoration: const BoxDecoration(
                color: AppColorPalette.gray200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fitness_center,
                  color: AppColorPalette.gray900),
            ),
            SizedBox(height: AppSpacing.space12.h),
            Text(
              exercise.name as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              exercise.category as String,
              style: AppTypography.textTheme.labelSmall?.copyWith(
                color: AppTextColor.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
