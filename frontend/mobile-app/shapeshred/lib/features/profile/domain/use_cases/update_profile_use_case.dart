import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfileUseCase implements UseCase<UserProfile, UserProfile> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfile profile) {
    return _repository.updateProfile(profile);
  }
}
