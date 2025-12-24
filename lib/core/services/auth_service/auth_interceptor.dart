import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import '../local_storage/auth_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._storage);

  final AuthStorageService _storage;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ❌ لو الريكوست نفسه refresh → logout
    if (err.requestOptions.path == ApiConstants.refreshToken) {
      log('❌ Refresh endpoint failed → clearing tokens');
      await _storage.clearTokens();
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    log('⚠️ 401 Detected → Trying refresh');

    try {
      final storedAccessToken = await _storage.getAccessToken();
      final requestToken = err.requestOptions.headers['Authorization']
          ?.toString()
          .replaceFirst('Bearer ', '');

      // 🔁 token اتجدّد قبل كده
      if (storedAccessToken != null &&
          requestToken != null &&
          storedAccessToken != requestToken) {
        log('🔁 Token already refreshed → retrying');
        return _retry(err.requestOptions, storedAccessToken, handler);
      }

      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        log('❌ No refresh token → logout');
        await _storage.clearTokens();
        return handler.next(err);
      }

      // 🔐 Dio خاص بالـ refresh (بدون interceptors)
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          receiveDataWhenStatusError: true,
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {
          "token": refreshToken, // 👈 حسب backend بتاعك
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await _storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        log('✅ Refresh success → retrying request');
        return _retry(err.requestOptions, newAccessToken, handler);
      }
    } catch (e) {
      log('❌ Refresh failed → $e');
      await _storage.clearTokens();
    }

    handler.next(err);
  }

  Future<void> _retry(
      RequestOptions requestOptions,
      String newToken,
      ErrorInterceptorHandler handler,
      ) async {
    final retryDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $newToken';

    try {
      final response = await retryDio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: headers,
        ),
      );

      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}