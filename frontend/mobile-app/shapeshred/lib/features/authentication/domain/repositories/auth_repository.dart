import '../entities/user.dart';
import '../use_cases/sign_up_use_case.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<void> signIn(String email, String password);
  Future<void> signUp(SignUpParams params);
  Future<void> signOut();
}
