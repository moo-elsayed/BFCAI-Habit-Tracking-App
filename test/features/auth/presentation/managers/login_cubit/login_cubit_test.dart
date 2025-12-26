import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/login_cubit/login_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLoginInputEntity extends Mock implements LoginInputEntity {}

void main() {
  late LoginCubit sut;
  late MockLoginUseCase mockLoginUseCase;
  late LoginInputEntity loginInput;
  late LoginResponseEntity loginResponse;

  setUpAll(() {
    registerFallbackValue(MockLoginInputEntity());

    loginInput = .new(email: 'test@mail.com', password: 'password');
    loginResponse = .new(
      email: 'test@mail.com',
      username: 'testuser',
      token: 'access_token',
      refreshToken: 'refresh_token',
      roles: const ['user'],
    );
  });

  setUp(() {
    mockLoginUseCase = .new();
    sut = .new(mockLoginUseCase);
  });

  tearDown(() {
    sut.close();
  });

  group('LoginCubit', () {
    test('initial state should be LoginInitial', () {
      expect(sut.state, isA<LoginInitial>());
    });
    blocTest(
      "should emit Login Success when login succeeds",
      build: () => sut,
      setUp: () {
        when(() => mockLoginUseCase.call(loginInput)).thenAnswer(
          (_) async => NetworkSuccess<LoginResponseEntity>(loginResponse),
        );
      },
      act: (_) => sut.login(loginInput),
      expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
      verify: (_) {
        verify(() => mockLoginUseCase.call(loginInput)).called(1);
        verifyNoMoreInteractions(mockLoginUseCase);
      },
    );

    blocTest(
      "should emit login failure when login fails",
      build: () => sut,
      setUp: () {
        when(() => mockLoginUseCase.call(loginInput)).thenAnswer(
          (_) async =>
              NetworkFailure<LoginResponseEntity>(Exception("login_failed")),
        );
      },
      act: (_) => sut.login(loginInput),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (failure) => failure.errorMessage,
          'errorMessage',
          'login_failed',
        ),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(loginInput)).called(1);
        verifyNoMoreInteractions(mockLoginUseCase);
      },
    );
  });
}
