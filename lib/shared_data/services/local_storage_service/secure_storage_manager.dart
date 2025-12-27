import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/local_storage/auth_storage_service.dart';

class SecureStorageManager implements AuthStorageService {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;
  final String _accessTokenKey = 'accessToken';
  final String _refreshTokenKey = 'refreshToken';
  final String _accessTokenExpiryKey = 'accessTokenExpiry';
  final String _refreshTokenExpiryKey = 'refreshTokenExpiry';

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiry,
    required DateTime refreshTokenExpiry,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(
      key: _accessTokenExpiryKey,
      value: accessTokenExpiry.toString(),
    );
    await _storage.write(
      key: _accessTokenExpiryKey,
      value: refreshTokenExpiry.toIso8601String(),
    );
  }

  @override
  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  @override
  Future<DateTime?> getAccessTokenExpiry() async => await _storage
      .read(key: _accessTokenExpiryKey)
      .then((value) => value == null ? null : DateTime.parse(value));

  @override
  Future<DateTime?> getRefreshTokenExpiry() async => await _storage
      .read(key: _refreshTokenExpiryKey)
      .then((value) => value == null ? null : DateTime.parse(value));

  @override
  Future<void> clearTokens() async => await _storage.deleteAll();
}
