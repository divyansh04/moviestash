import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/network/http_client_service.dart';

import '../constants/api_constants.dart';

@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl implements HttpClientService {

  HttpClientServiceImpl() {
    _dio = _createDio();
    _setupInterceptors();
  }
  late final Dio _dio;

  @override
  Dio get dio => _dio;

  Dio _createDio() {
    final options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    return Dio(options);
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = ApiConstants.apiKey;
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('🌐 $obj'),
        ),
      );
    }
  }
}
