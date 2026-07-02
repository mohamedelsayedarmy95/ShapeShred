import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/exercise.dart';
import '../repositories/training_repository.dart';

@injectable
class GetExercisesUseCase implements UseCase<List<Exercise>, NoParams> {
  final TrainingRepository _repository;

  GetExercisesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(NoParams params) {
    return _repository.getExercises();
  }
}
