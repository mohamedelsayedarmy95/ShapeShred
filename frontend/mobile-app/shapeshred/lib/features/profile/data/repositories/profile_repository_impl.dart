import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/network/dio_client.dart';
import 'package:shapeshred/core/error/failures.dart';
import 'package:shapeshred/features/profile/domain/entities/user_profile.dart';
import 'package:shapeshred/features/profile/domain/repositories/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;

  ProfileRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final response =
          await _dioClient.dio.get<Map<String, dynamic>>('http://localhost:3002/users/profile');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Right(_mapToEntity(data));
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
      UserProfile profile) async {
    try {
      final response = await _dioClient.dio.put<Map<String, dynamic>>(
        'http://localhost:3002/users/profile',
        data: {
          'firstName': profile.firstName,
          'lastName': profile.lastName,
          'dateOfBirth': profile.dateOfBirth?.toIso8601String(),
          'gender': profile.gender,
          'heightCm': profile.heightCm,
          'weightKg': profile.weightKg,
          'fitnessLevel': profile.fitnessLevel,
          'goal': profile.goal,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Right(_mapToEntity(data));
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  UserProfile _mapToEntity(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      heightCm: json['heightCm'] != null
          ? double.parse(json['heightCm'].toString())
          : null,
      weightKg: json['weightKg'] != null
          ? double.parse(json['weightKg'].toString())
          : null,
      fitnessLevel: json['fitnessLevel'] as String?,
      goal: json['goal'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
