import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/calories_hero_card.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/macro_breakdown.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/meal_list_item.dart';
import 'package:shapeshred/features/nutrition/presentation/widgets/water_tracker.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  String _userName = 'User';
  String _userGoal = '';
  String _userFitnessLevel = '';
  bool _isLoading = true;

  // Default nutrition goals (can be personalized later with more user data)
  int _calorieGoal = 2200;
  int _proteinGoal = 150;
  int _carbsGoal = 250;
  int _fatGoal = 70;
  int _waterGoal = 8;

  // Current intake (mock data - in real app this would come from a database)
  int _caloriesConsumed = 1450;
  int _proteinConsumed = 95;
  int _carbsConsumed = 180;
  int _fatConsumed = 55;
  int _waterConsumed = 5;

  String _motivationalMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Try to get data from Firestore first
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (exists && doc.data() != null) {
          final data = doc.data()!;
          setState(() {
            _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
            _userGoal = data['goal'] ?? '';
            _userFitnessLevel = data['fitnessLevel'] ?? '';
          });
        } else {
          // Fallback to SharedPreferences for goal and fitness level
          _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
          _userGoal = await PreferencesService.getUserGoal() ?? '';
          _userFitnessLevel =
              await PreferencesService.getFitnessLevel() ?? '';
        }
      }

      // Set motivational message based on goal
      switch (_userGoal) {
        case 'Lose Weight':
          _motivationalMessage =
              'You\'re on a weight loss journey. Aim for a calorie deficit.';
          // Adjust goals for weight loss (example values)
          _calorieGoal = 1800;
          _proteinGoal = 120;
          _carbsGoal = 200;
          _fatGoal = 50;
          break;
        case 'Build Muscle':
          _motivationalMessage =
              'You\'re building muscle. Make sure to get enough protein.';
          // Adjust goals for muscle gain (example values)
          _calorieGoal = 2500;
          _proteinGoal = 180;
          _carbsGoal = 250;
          _fatGoal = 70;
          break;
        case 'Endurance':
          _motivationalMessage =
              'You\'re building endurance. Focus on carbs for energy.';
          // Adjust goals for endurance (example values)
          _calorieGoal = 2400;
          _proteinGoal = 100;
          _carbsGoal = 300;
          _fatGoal = 60;
          break;
        case 'Stay Fit':
          _motivationalMessage =
              'Maintain a balanced diet to stay healthy and active.';
          // Keep default goals for general fitness
          break;
        default:
          _motivationalMessage = 'Track your nutrition to reach your goals.';
          break;
      }

      // Adjust water goal based on weight? We don't have weight, so keep default
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Fallback to defaults
      final user = FirebaseAuth.instance.currentUser;
      _userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
      _userGoal = '';
      _userFitnessLevel = '';
      _motivationalMessage = 'Track your nutrition to reach your goals.';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColorPalette.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
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
                    'Hello, $_userName!',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColorPalette.gray900,
                    ),
                  ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    _motivationalMessage,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.w),
              child: Divider(
                color: AppColorPalette.gray200,
                height: 1,
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
                    WaterTracker(
                      current: _waterConsumed,
                      goal: _waterGoal,
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