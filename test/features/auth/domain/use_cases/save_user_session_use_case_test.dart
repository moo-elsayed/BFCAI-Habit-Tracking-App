import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/save_user_session_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockAuthStorageService extends Mock implements AuthStorageService {}

void main() {
  late SaveUserSessionUseCase sut;
  late MockAppPreferencesService mockAppPreferencesService;
  late MockAuthStorageService mockAuthStorageService;
  late LoginResponseEntity loginResponseEntity;

  setUpAll(() {
    loginResponseEntity = .new(
      email: "kddkd@gmail.com",
      username: "johndoe",
      token: "access_token",
      refreshToken: "refresh_token",
      roles: ["user"],
    );
  });

  setUp(() {
    mockAppPreferencesService = .new();
    mockAuthStorageService = .new();
    sut = .new(mockAppPreferencesService, mockAuthStorageService);
  });

  group("SaveUserSessionUseCase", () {
    test("should save user session data successfully", () async {
      // Arrange
      when(
        () => mockAppPreferencesService.setLoggedIn(true),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.setUsername("johndoe"),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.setEmailAddress("kddkd@gmail.com"),
      ).thenAnswer((_) async => true);
      when(
        () => mockAuthStorageService.saveTokens(
          accessToken: "access_token",
          refreshToken: "refresh_token",
        ),
      ).thenAnswer((_) async => true);
      // Act
      await sut.call(loginResponseEntity);
      // Assert
      verify(() => mockAppPreferencesService.setLoggedIn(true)).called(1);
      verify(() => mockAppPreferencesService.setUsername("johndoe")).called(1);
      verify(
        () => mockAppPreferencesService.setEmailAddress("kddkd@gmail.com"),
      ).called(1);
      verify(
        () => mockAuthStorageService.saveTokens(
          accessToken: "access_token",
          refreshToken: "refresh_token",
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAppPreferencesService);
      verifyNoMoreInteractions(mockAuthStorageService);
    });
    test("should throw exception when save tokens fails", () {
      // Arrange
      when(
        () => mockAppPreferencesService.setLoggedIn(true),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.setUsername("johndoe"),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.setEmailAddress("kddkd@gmail.com"),
      ).thenAnswer((_) async => true);
      when(
        () => mockAuthStorageService.saveTokens(
          accessToken: "access_token",
          refreshToken: "refresh_token",
        ),
      ).thenThrow(Exception("error"));
      // Act
      var call = sut.call(loginResponseEntity);
      // Assert
      expect(
        () => call,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "error",
            "Exception: failed_to_save_user_session",
          ),
        ),
      );
      verify(() => mockAppPreferencesService.setLoggedIn(true)).called(1);
      verify(() => mockAppPreferencesService.setUsername("johndoe")).called(1);
      verify(
        () => mockAppPreferencesService.setEmailAddress("kddkd@gmail.com"),
      ).called(1);
      verify(
        () => mockAuthStorageService.saveTokens(
          accessToken: "access_token",
          refreshToken: "refresh_token",
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAppPreferencesService);
      verifyNoMoreInteractions(mockAuthStorageService);
    });
  });
}
