import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/network/dio_client.dart';
import 'package:shapeshred/core/error/failures.dart';
import 'package:shapeshred/features/training/domain/entities/exercise.dart';
import 'package:shapeshred/features/training/domain/repositories/training_repository.dart';

@Injectable(as: TrainingRepository)
class TrainingRepositoryImpl implements TrainingRepository {
  final DioClient _dioClient;

  TrainingRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, List<Exercise>>> getExercises() async {
    try {
      final response =
          await _dioClient.dio.get<List<dynamic>>('http://localhost:3003/exercises');
      if (response.statusCode == 200) {
        final data = response.data!;
        return Right(data
            .map((json) => _mapToEntity(json as Map<String, dynamic>))
            .toList());
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByCategory(
      String category) async {
    try {
      final response = await _dioClient.dio.get<List<dynamic>>(
          'http://localhost:3003/exercises',
          queryParameters: {'category': category});
      if (response.statusCode == 200) {
        final data = response.data!;
        return Right(data
            .map((json) => _mapToEntity(json as Map<String, dynamic>))
            .toList());
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Exercise _mapToEntity(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      equipmentRequired: json['equipmentRequired'] as String,
      targetMuscles: List<String>.from(json['targetMuscles'] as Iterable? ?? []),
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      instructions: List<String>.from(json['instructions'] as Iterable? ?? []),
      formTips: List<String>.from(json['formTips'] as Iterable? ?? []),
      caloriesPerMinute: json['caloriesPerMinute'] != null
          ? double.parse(json['caloriesPerMinute'].toString())
          : null,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}
