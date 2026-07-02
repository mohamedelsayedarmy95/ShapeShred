import 'package:equatable/equatable.dart';

class NutritionPlan extends Equatable {
  final String id;
  final String userId;
  final String name;
  final double dailyCalories;
  final double dailyProteinG;
  final double dailyCarbsG;
  final double dailyFatG;
  final List<Meal> meals;

  const NutritionPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.dailyCalories,
    required this.dailyProteinG,
    required this.dailyCarbsG,
    required this.dailyFatG,
    required this.meals,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        dailyCalories,
        dailyProteinG,
        dailyCarbsG,
        dailyFatG,
        meals
      ];
}

class Meal extends Equatable {
  final String id;
  final String name;
  final String mealType;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const Meal({
    required this.id,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  @override
  List<Object?> get props =>
      [id, name, mealType, calories, proteinG, carbsG, fatG];
}
