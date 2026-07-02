import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutrition_plan.dart';
import '../repositories/nutrition_repository.dart';

@injectable
class GetActivePlanUseCase implements UseCase<NutritionPlan, NoParams> {
  final NutritionRepository _repository;

  GetActivePlanUseCase(this._repository);

  @override
  Future<Either<Failure, NutritionPlan>> call(NoParams params) {
    return _repository.getActivePlan();
  }
}
