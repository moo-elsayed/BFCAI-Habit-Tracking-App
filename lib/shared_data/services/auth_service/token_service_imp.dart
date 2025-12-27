import 'package:dio/dio.dart';
import '../../../core/helpers/api_constants.dart';
import '../../../core/services/auth_service/token_service.dart';
import '../../../core/services/local_storage/auth_storage_service.dart';

class TokenServiceImpl implements TokenService {
  final AuthStorageService _storage;

  TokenServiceImpl(this._storage);

  @override
  Future<void> refreshTokenSilently() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final response = await dio.post(
      ApiConstants.refreshToken,
      data: {"token": refreshToken},
    );

    if (response.statusCode != 200) {
      throw Exception('Refresh failed');
    }

    final newAccessToken = response.data['data']['token'];
    final newRefreshToken = response.data['data']['refreshToken'];
    final newRefreshTokenExpiry =
        response.data['data']['refreshTokenExpiration'];

    await _storage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      accessTokenExpiry: DateTime.now().add(const Duration(minutes: 15)),
      refreshTokenExpiry: DateTime.parse(newRefreshTokenExpiry),
    );
  }
}
