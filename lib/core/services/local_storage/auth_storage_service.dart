abstract class AuthStorageService {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiry,
    required DateTime refreshTokenExpiry,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<DateTime?> getAccessTokenExpiry();

  Future<DateTime?> getRefreshTokenExpiry();

  Future<void> clearTokens();
}
