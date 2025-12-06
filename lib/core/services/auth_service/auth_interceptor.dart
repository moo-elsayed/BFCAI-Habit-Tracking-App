import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import '../local_storage/auth_storage_service.dart';

class AuthInterceptor extends Interceptor {
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
      try {
        final refreshToken = await _storage.getRefreshToken();

        if (refreshToken == null) {
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
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['token'];
          final newRefreshToken = response.data['refreshToken'];

          await _storage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final clonedRequest = await _dio.request(
            opts.path,
            options: Options(method: opts.method, headers: opts.headers),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          return handler.resolve(clonedRequest);
        }
      } catch (e) {
        await _storage.clearTokens();
      }
    }
    return handler.next(err);
  }
}
