import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/local_storage/auth_storage_service.dart';

class SecureStorageManager implements AuthStorageService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async =>
      await _storage.read(key: 'accessToken');

  @override
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: 'refreshToken');

  @override
  Future<void> clearTokens() async => await _storage.deleteAll();
}
