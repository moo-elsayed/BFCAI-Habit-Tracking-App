import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import '../local_storage/auth_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._dio, this._storage);

  final Dio _dio;
  final AuthStorageService _storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log("⚠️ 401 Detected - Attempting Refresh...");

      try {
        final currentTokenInStorage = await _storage.getAccessToken();
        final tokenInRequest = err.requestOptions.headers['Authorization']
            ?.toString()
            .replaceAll('Bearer ', '');

        if (currentTokenInStorage != null &&
            tokenInRequest != null &&
            currentTokenInStorage != tokenInRequest) {
          log("🔁 Token already refreshed by another request. Retrying...");
          return _retry(err.requestOptions, currentTokenInStorage, handler);
        }

        final refreshToken = await _storage.getRefreshToken();

        if (refreshToken == null) {
          log("❌ No Refresh Token found in storage.");
          return handler.next(err);
        }

        final tokenDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final response = await tokenDio.post(
          ApiConstants.refreshToken,
          data: {"token": refreshToken},
        );

        if (response.statusCode == 200) {
          log("✅ Refresh Successful!");
          final newAccessToken = response.data['data']['token'];
          final newRefreshToken = response.data['data']['refreshToken'];

          await _storage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          return _retry(err.requestOptions, newAccessToken, handler);
        }
      } on DioException catch (e) {
        log("❌ Refresh Failed with DioError: ${e.response?.statusCode}");

        if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
          await _storage.clearTokens();
        }
        return handler.next(err);
      } catch (e) {
        log("❌ Refresh Failed with Exception: $e");
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $newToken'},
    );

    try {
      final response = await _dio.fetch(
        requestOptions.copyWith(headers: options.headers),
      );
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
