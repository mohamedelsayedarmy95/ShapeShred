import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/atoms/skeleton_loader.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/calories_hero_card.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/macro_breakdown.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/meal_list_item.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/water_tracker.dart';
import 'package:shapeshred/features/nutrition/domain/models/food.dart' as food_models;
import 'package:shapeshred/features/nutrition/presentation/pages/meal_logging_page.dart';
import 'package:shapeshred/providers/user_data_provider.dart';
import 'package:shapeshred/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NutritionPage extends ConsumerStatefulWidget {
  const NutritionPage({super.key});

  @override
  ConsumerState<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends ConsumerState<NutritionPage> {
  String _userName = 'User';
  String _userGoal = '';
  String _userFitnessLevel = '';
  bool _isLoading = true;

  // Default nutrition goals (can be personalized later with more user data)
  int _calorieGoal = 2200;
  int _proteinGoal = 150;
  int _carbsGoal = 250;
  int _fatGoal = 70;
  final int _waterGoal = 8;

  // Today's logged meals (users/{uid}/meals), newest first.
  List<food_models.Meal> _todayMeals = [];
  int _waterConsumed = 0;

  int get _caloriesConsumed =>
      _todayMeals.fold(0, (sum, m) => sum + m.totalCalories);
  int get _proteinConsumed =>
      _todayMeals.fold(0.0, (sum, m) => sum + m.totalProtein).round();
  int get _carbsConsumed =>
      _todayMeals.fold(0.0, (sum, m) => sum + m.totalCarbs).round();
  int get _fatConsumed =>
      _todayMeals.fold(0.0, (sum, m) => sum + m.totalFat).round();

  String _motivationalMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ref.read(userDataProvider.future);
      if (profile != null && mounted) {
        _userName = profile.displayName;
        _userGoal = profile.goal;
        _userFitnessLevel = profile.fitnessLevel;
      }

      switch (_userGoal) {
        case 'Lose Weight':
          _motivationalMessage =
              'You\'re on a weight loss journey. Aim for a calorie deficit.';
          _calorieGoal = 1800;
          _proteinGoal = 120;
          _carbsGoal = 200;
          _fatGoal = 50;
          break;
        case 'Build Muscle':
          _motivationalMessage =
              'You\'re building muscle. Make sure to get enough protein.';
          _calorieGoal = 2500;
          _proteinGoal = 180;
          _carbsGoal = 250;
          _fatGoal = 70;
          break;
        case 'Endurance':
          _motivationalMessage =
              'You\'re building endurance. Focus on carbs for energy.';
          _calorieGoal = 2400;
          _proteinGoal = 100;
          _carbsGoal = 300;
          _fatGoal = 60;
          break;
        case 'Stay Fit':
          _motivationalMessage =
              'Maintain a balanced diet to stay healthy and active.';
          break;
        default:
          _motivationalMessage = 'Track your nutrition to reach your goals.';
          break;
      }

      await _loadTodayMeals();
      await _loadTodayWater();
    } catch (e) {
      debugPrint('NutritionPage: error loading data: $e');
      _motivationalMessage = 'Track your nutrition to reach your goals.';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTodayMeals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final DateTime now = DateTime.now();
    final String dayStart =
        DateTime(now.year, now.month, now.day).toIso8601String();
    final String dayEnd =
        DateTime(now.year, now.month, now.day + 1).toIso8601String();

    // Meal.date is stored as an ISO-8601 string, which sorts
    // lexicographically in chronological order.
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .where('date', isGreaterThanOrEqualTo: dayStart)
        .where('date', isLessThan: dayEnd)
        .orderBy('date')
        .get();

    _todayMeals = snapshot.docs
        .map((doc) => food_models.Meal.fromJson(doc.data()))
        .toList();
  }

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadTodayWater() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(_todayKey)
        .get();

    _waterConsumed = (doc.data()?['water'] as num?)?.toInt() ?? 0;
  }

  Future<void> _setWater(int glasses) async {
    setState(() => _waterConsumed = glasses);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('daily_logs')
          .doc(_todayKey)
          .set({
        'water': glasses,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to save water intake: $e');
    }
  }

  Future<void> _openMealLogging() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MealLoggingPage()),
    );
    // Refresh totals after a meal may have been saved.
    if (!mounted) return;
    await _loadTodayMeals();
    if (mounted) setState(() {});
  }

  IconData _mealTypeIcon(String type) {
    switch (type) {
      case 'breakfast':
        return Icons.wb_sunny_outlined;
      case 'lunch':
        return Icons.restaurant;
      case 'dinner':
        return Icons.nights_stay_outlined;
      default:
        return Icons.coffee;
    }
  }

  String _mealTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      case 'snack':
        return l10n.snack;
      default:
        return _capitalize(type);
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.screenPadding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 160.w, height: 30.h),
                SizedBox(height: AppSpacing.space8.h),
                SkeletonLoader(width: 220.w, height: 16.h),
                SizedBox(height: AppSpacing.space24.h),
                SkeletonCard(height: 200.h),
                SizedBox(height: AppSpacing.space24.h),
                const SkeletonStatsRow(),
                SizedBox(height: AppSpacing.space32.h),
                SkeletonLoader(width: 140.w, height: 22.h),
                SizedBox(height: AppSpacing.space16.h),
                const SkeletonList(itemCount: 3),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.w,
                vertical: AppSpacing.space16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.helloUser(_userName),
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppTextColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    _motivationalMessage,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Divider(
                color: AppColors.outline,
                height: 1,
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.w,
                ),
                child: _FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calories Hero Card
                      CaloriesHeroCard(
                        consumed: _caloriesConsumed,
                        goal: _calorieGoal,
                      ),
                      SizedBox(height: AppSpacing.space24.h),

                      // Macro Breakdown
                      MacroBreakdown(
                        protein: _proteinConsumed,
                        proteinGoal: _proteinGoal,
                        carbs: _carbsConsumed,
                        carbsGoal: _carbsGoal,
                        fat: _fatConsumed,
                        fatGoal: _fatGoal,
                      ),
                      SizedBox(height: AppSpacing.space32.h),

                      // Section Title: Meals
                      Text(
                        AppLocalizations.of(context)!.todaysMeals,
                        style: AppTypography.headlineSmall,
                      ),
                      SizedBox(height: AppSpacing.space16.h),

                      // Meals List (real data from users/{uid}/meals)
                      if (_todayMeals.isEmpty)
                        GestureDetector(
                          onTap: _openMealLogging,
                          child: MealListItem(
                            mealType:
                                AppLocalizations.of(context)!.noMealsYet,
                            time: '',
                            calories: 0,
                            items: AppLocalizations.of(context)!
                                .tapToLogFirstMeal,
                            icon: Icons.restaurant_menu,
                            isEmpty: true,
                          ),
                        )
                      else
                        ...[
                          for (final meal in _todayMeals) ...[
                            MealListItem(
                              mealType: _mealTypeLabel(context, meal.type),
                              time: DateFormat('h:mm a').format(meal.date),
                              calories: meal.totalCalories,
                              items: meal.items
                                  .map((i) => i.food.name)
                                  .join(', '),
                              icon: _mealTypeIcon(meal.type),
                            ),
                            SizedBox(height: AppSpacing.space12.h),
                          ],
                        ],
                      SizedBox(height: AppSpacing.space32.h),

                      // Water Tracker
                      WaterTracker(
                        current: _waterConsumed,
                        goal: _waterGoal,
                        onChanged: _setWater,
                      ),
                      SizedBox(height: AppSpacing.space32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openMealLogging,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: AppColors.onPrimary),
        label: Text(
          AppLocalizations.of(context)!.addMeal,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// Fades and slides its child up once, on first build after data loads.
class _FadeSlideIn extends StatelessWidget {
  final Widget child;

  const _FadeSlideIn({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.cinematic,
      curve: AppCurves.premiumFluid,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
