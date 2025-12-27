import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/save_user_session_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockSaveUserSessionUseCase extends Mock
    implements SaveUserSessionUseCase {}

class MockLoginInputEntity extends Mock implements LoginInputEntity {}

void main() {
  late LoginUseCase sut;
  late MockAuthRepo mockAuthRepo;
  late MockSaveUserSessionUseCase mockSaveUserSession;
  late LoginInputEntity loginInput;
  late LoginResponseEntity loginResponse;

  setUpAll(() {
    registerFallbackValue(MockLoginInputEntity());

    loginInput = .new(
      email: 'test@mail.com',
      password: 'password',
    );

    loginResponse = .new(
      email: 'test@mail.com',
      username: 'testuser',
      token: 'access_token',
      refreshToken: 'refresh_token',
      roles: const ['user'],
      refreshTokenExpiration: DateTime.now(),
    );
  });

  setUp(() {
    mockAuthRepo = .new();
    mockSaveUserSession = .new();
    sut = .new(mockAuthRepo, mockSaveUserSession);
  });

  group('LoginUseCase', () {
    test(
      'should return NetworkSuccess and save session when login succeeds',
          () async {
        // Arrange
        when(() => mockAuthRepo.login(loginInput))
            .thenAnswer((_) async => NetworkSuccess(loginResponse));

        when(() => mockSaveUserSession.call(loginResponse))
            .thenAnswer((_) async {});

        // Act
        final result = await sut.call(loginInput);

        // Assert
        expect(result, isA<NetworkSuccess<LoginResponseEntity>>());
        expect((result as NetworkSuccess).data.email, 'test@mail.com');
        expect((result as NetworkSuccess).data.username, 'testuser');
        verify(() => mockAuthRepo.login(loginInput)).called(1);
        verify(() => mockSaveUserSession.call(loginResponse)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNoMoreInteractions(mockSaveUserSession);
      },
    );

    test(
      'should return NetworkFailure when login fails',
          () async {
        // Arrange
        when(() => mockAuthRepo.login(loginInput))
            .thenAnswer((_) async => NetworkFailure(Exception('login_failed')));

        // Act
        final result = await sut.call(loginInput);

        // Assert
        expect(result, isA<NetworkFailure<LoginResponseEntity>>());
        expect(getErrorMessage(result), 'login_failed');
        verify(() => mockAuthRepo.login(loginInput)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNever(() => mockSaveUserSession.call(loginResponse));
      },
    );

    test(
      'should return NetworkFailure when saving user session fails',
          () async {
        // Arrange
        when(() => mockAuthRepo.login(loginInput))
            .thenAnswer((_) async => NetworkSuccess(loginResponse));

        when(() => mockSaveUserSession.call(loginResponse))
            .thenThrow(Exception('failed_to_save_user_session'));

        // Act
        final result = await sut.call(loginInput);

        // Assert
        expect(result, isA<NetworkFailure<LoginResponseEntity>>());
        expect(getErrorMessage(result), 'failed_to_save_user_session');
        verify(() => mockAuthRepo.login(loginInput)).called(1);
        verify(() => mockSaveUserSession.call(loginResponse)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
        verifyNoMoreInteractions(mockSaveUserSession);
      },
    );
  });
}
