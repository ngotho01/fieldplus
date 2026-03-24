import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

final dioClientProvider = Provider<Dio>((ref) => DioClient.instance);

class DioClient {
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: AppConstants.accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final refreshed = await _attemptRefresh();
              if (refreshed) {
                final opts = error.requestOptions;
                final token = await _storage.read(key: AppConstants.accessTokenKey);
                opts.headers['Authorization'] = 'Bearer $token';
                final retryDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
                final response = await retryDio.fetch(opts);
                return handler.resolve(response);
              }
            } catch (_) {
              await _storage.deleteAll();
            }
          }
          handler.next(_mapError(error));
        },
      ),
    );

    return dio;
  }

  static Future<bool> _attemptRefresh() async {
    final refresh = await _storage.read(key: AppConstants.refreshTokenKey);
    if (refresh == null) return false;

    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    final response = await dio.post(
      ApiConstants.refresh,
      data: {'refresh': refresh},
    );

    if (response.statusCode == 200) {
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.data['access'] as String,
      );
      return true;
    }
    return false;
  }

  static DioException _mapError(DioException e) {
    return e; // pass through; repositories handle mapping
  }
}