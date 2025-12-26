import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/clear_user_session_use_case.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockClearUserSessionUseCase extends Mock
    implements ClearUserSessionUseCase {}

void main() {
  late LogoutUseCase sut;
  late MockAuthRepo mockAuthRepo;
  late MockClearUserSessionUseCase mockClearUserSession;

  setUp(() {
    mockAuthRepo = .new();
    mockClearUserSession = .new();
    sut = .new(mockAuthRepo, mockClearUserSession);
  });

  group('LogoutUseCase', () {
    test(
      'should return NetworkSuccess and clear user session when logout succeeds',
          () async {
        // Arrange
        when(() => mockAuthRepo.logout())
            .thenAnswer((_) async => const NetworkSuccess<String>('success'));

        when(() => mockClearUserSession.call())
            .thenAnswer((_) async {});

        // Act
        final result = await sut.call();

        // Assert
        expect(result, isA<NetworkSuccess<String>>());
        expect((result as NetworkSuccess).data, 'success');

        verify(() => mockAuthRepo.logout()).called(1);
        verify(() => mockClearUserSession.call()).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNoMoreInteractions(mockClearUserSession);
      },
    );

    test(
      'should return NetworkFailure when logout fails',
          () async {
        // Arrange
        when(() => mockAuthRepo.logout()).thenAnswer(
              (_) async => NetworkFailure<String>(Exception('logout_failed')),
        );

        // Act
        final result = await sut.call();

        // Assert
        expect(result, isA<NetworkFailure<String>>());
        expect(getErrorMessage(result), 'logout_failed');

        verify(() => mockAuthRepo.logout()).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNever(() => mockClearUserSession.call());
      },
    );

    test(
      'should return NetworkFailure when clearing user session fails',
          () async {
        // Arrange
        when(() => mockAuthRepo.logout())
            .thenAnswer((_) async => const NetworkSuccess<String>('success'));

        when(() => mockClearUserSession.call())
            .thenThrow(Exception('failed_to_clear_user_session'));

        // Act
        final result = await sut.call();

        // Assert
        expect(result, isA<NetworkFailure<String>>());
        expect(getErrorMessage(result), 'failed_to_clear_user_session');

        verify(() => mockAuthRepo.logout()).called(1);
        verify(() => mockClearUserSession.call()).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNoMoreInteractions(mockClearUserSession);
      },
    );
  });
}
