import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  final String baseUrl = 'http://localhost:8000/api';

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    // Add interceptors for logging if needed
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    String errorMessage = '';
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
      case DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error';
      default:
        errorMessage = 'Something went wrong: ${e.message}';
    }
    return Exception(errorMessage);
  }
}
