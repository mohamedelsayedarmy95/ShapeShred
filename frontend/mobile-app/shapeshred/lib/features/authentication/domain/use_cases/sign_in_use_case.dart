import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInUseCase implements UseCase<void, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SignInParams params) async {
    try {
      await _repository.signIn(params.email, params.password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
