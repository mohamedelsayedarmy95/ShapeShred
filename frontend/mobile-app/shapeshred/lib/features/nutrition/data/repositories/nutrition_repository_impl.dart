import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/network/dio_client.dart';
import 'package:shapeshred/core/error/failures.dart';
import 'package:shapeshred/features/nutrition/domain/entities/nutrition_plan.dart';
import 'package:shapeshred/features/nutrition/domain/repositories/nutrition_repository.dart';

@Injectable(as: NutritionRepository)
class NutritionRepositoryImpl implements NutritionRepository {
  final DioClient _dioClient;

  NutritionRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, NutritionPlan>> getActivePlan() async {
    try {
      final response = await _dioClient.dio
          .get<Map<String, dynamic>>('http://localhost:3004/nutrition/active-plan');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Right(_mapToEntity(data));
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  NutritionPlan _mapToEntity(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      dailyCalories: double.parse(json['dailyCalories'].toString()),
      dailyProteinG: double.parse(json['dailyProteinG'].toString()),
      dailyCarbsG: double.parse(json['dailyCarbsG'].toString()),
      dailyFatG: double.parse(json['dailyFatG'].toString()),
      meals: (json['meals'] as List)
          .map((m) => Meal(
                id: m['id'] as String,
                name: m['name'] as String,
                mealType: m['mealType'] as String,
                calories: double.parse(m['calories'].toString()),
                proteinG: double.parse(m['proteinG'].toString()),
                carbsG: double.parse(m['carbsG'].toString()),
                fatG: double.parse(m['fatG'].toString()),
              ))
          .toList(),
    );
  }
}
