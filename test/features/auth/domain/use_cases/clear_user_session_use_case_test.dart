import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
import 'package:habit_tracking_app/core/services/notification_service/notification_service.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/clear_user_session_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockAuthStorageService extends Mock implements AuthStorageService {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late ClearUserSessionUseCase sut;
  late MockAppPreferencesService mockAppPreferencesService;
  late MockAuthStorageService mockAuthStorageService;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockAppPreferencesService = .new();
    mockAuthStorageService = .new();
    mockNotificationService = .new();
    sut = .new(
      mockAppPreferencesService,
      mockAuthStorageService,
      mockNotificationService,
    );
  });

  group("ClearUserSessionUseCase", () {
    test("should clear user session data successfully", () async {
      // Arrange
      when(
        () => mockAppPreferencesService.setLoggedIn(false),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.deleteUseName(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.deleteEmailAddress(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAuthStorageService.clearTokens(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.deleteHabitsScheduled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockNotificationService.cancelAll(),
      ).thenAnswer((_) async => true);
      // Act
      await sut.call();
      // Assert
      verify(() => mockAppPreferencesService.setLoggedIn(false)).called(1);
      verify(() => mockAppPreferencesService.deleteUseName()).called(1);
      verify(() => mockAppPreferencesService.deleteEmailAddress()).called(1);
      verify(() => mockAuthStorageService.clearTokens()).called(1);
      verify(() => mockAppPreferencesService.deleteHabitsScheduled()).called(1);
      verify(() => mockNotificationService.cancelAll()).called(1);
      verifyNoMoreInteractions(mockAppPreferencesService);
      verifyNoMoreInteractions(mockAuthStorageService);
      verifyNoMoreInteractions(mockNotificationService);
    });

    test("should throw exception when clear tokens fails", () {
      // Arrange
      when(
        () => mockAppPreferencesService.setLoggedIn(false),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.deleteUseName(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAppPreferencesService.deleteEmailAddress(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAuthStorageService.clearTokens(),
      ).thenThrow(Exception("error"));
      when(
        () => mockAppPreferencesService.deleteHabitsScheduled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockNotificationService.cancelAll(),
      ).thenAnswer((_) async => true);
      // Act
      var call = sut.call();
      // Assert
      expect(
        () => call,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "error",
            "Exception: failed_to_clear_user_session",
          ),
        ),
      );
      verify(() => mockAuthStorageService.clearTokens()).called(1);
    });
  });
}
