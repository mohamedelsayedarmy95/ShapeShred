import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetProfileUseCase implements UseCase<UserProfile, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return _repository.getProfile();
  }
}
