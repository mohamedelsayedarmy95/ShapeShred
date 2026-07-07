class Food {
  final String id;
  final String name;
  final String brand;
  final int servingSize; // in grams
  final String servingUnit;
  final int calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fat; // in grams
  final double fiber; // in grams
  final double sugar; // in grams
  final String? barcode;
  final String category;

  Food({
    required this.id,
    required this.name,
    required this.brand,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    this.barcode,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'barcode': barcode,
      'category': category,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      servingSize: json['servingSize'] as int,
      servingUnit: json['servingUnit'] as String,
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      barcode: json['barcode'] as String?,
      category: json['category'] as String,
    );
  }
}

class Meal {
  final String id;
  final String type; // breakfast, lunch, dinner, snack
  final DateTime date;
  final List<MealItem> items;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  Meal({
    required this.id,
    required this.type,
    required this.date,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List)
          .map((item) => MealItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCalories: json['totalCalories'] as int,
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
    );
  }
}

class MealItem {
  final Food food;
  final double quantity; // in grams
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  MealItem({
    required this.food,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      food: Food.fromJson(json['food'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  static MealItem fromFood(Food food, double quantity) {
    final ratio = quantity / food.servingSize;
    return MealItem(
      food: food,
      quantity: quantity,
      calories: (food.calories * ratio).round(),
      protein: food.protein * ratio,
      carbs: food.carbs * ratio,
      fat: food.fat * ratio,
    );
  }
}
