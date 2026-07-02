import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'interceptors/auth_interceptor.dart';

@lazySingleton
class DioClient {
  final Dio dio;

  DioClient(AuthInterceptor authInterceptor)
      : dio = Dio(
          BaseOptions(
            baseUrl: 'http://localhost:3001', // Local Auth Service
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }
}
