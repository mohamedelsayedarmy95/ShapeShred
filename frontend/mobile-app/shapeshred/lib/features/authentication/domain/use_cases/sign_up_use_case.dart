import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    try {
      await _repository.signUp(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}
