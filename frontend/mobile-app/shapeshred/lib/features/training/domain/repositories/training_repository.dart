import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exercise.dart';

abstract class TrainingRepository {
  Future<Either<Failure, List<Exercise>>> getExercises();
  Future<Either<Failure, List<Exercise>>> getExercisesByCategory(
      String category);
}
