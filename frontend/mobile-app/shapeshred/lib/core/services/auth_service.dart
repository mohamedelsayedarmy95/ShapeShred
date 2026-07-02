import 'package:injectable/injectable.dart';
import '../storage/secure_storage.dart';

@lazySingleton
class AuthService {
  final SecureStorage _secureStorage;
  static const String _tokenKey = 'auth_token';

  AuthService(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(_tokenKey);
  }

  Future<void> logout() async {
    await _secureStorage.delete(_tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}
