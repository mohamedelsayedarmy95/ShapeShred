import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/network/dio_client.dart';
import 'package:shapeshred/core/services/auth_service.dart';
import 'package:shapeshred/features/authentication/domain/repositories/auth_repository.dart';
import 'package:shapeshred/features/authentication/domain/entities/user.dart';
import 'package:shapeshred/features/authentication/domain/use_cases/sign_up_use_case.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final AuthService _authService;

  AuthRepositoryImpl(this._dioClient, this._authService);

  @override
  Future<User?> getCurrentUser() async {
    // To be implemented with /auth/me endpoint
    return null;
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>('/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final token = data['access_token'] as String;
      await _authService.saveToken(token);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  @override
  Future<void> signUp(SignUpParams params) async {
    final response =
        await _dioClient.dio.post<Map<String, dynamic>>('/auth/register', data: params.toJson());

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to sign up');
    }
  }

  @override
  Future<void> signOut() async {
    await _authService.logout();
  }
}
