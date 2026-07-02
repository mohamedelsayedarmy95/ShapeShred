import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutrition_plan.dart';

abstract class NutritionRepository {
  Future<Either<Failure, NutritionPlan>> getActivePlan();
}
