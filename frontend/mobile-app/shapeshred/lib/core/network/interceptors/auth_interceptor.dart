import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../services/auth_service.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // TODO: Implement refresh token logic here
      // For now, just logout if token is invalid
      await _authService.logout();
    }
    return handler.next(err);
  }
}
