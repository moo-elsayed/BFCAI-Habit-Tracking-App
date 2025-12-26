import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/logout_cubit/logout_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late LogoutCubit sut;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockLogoutUseCase = .new();
    sut = .new(mockLogoutUseCase);
  });

  tearDown(() {
    sut.close();
  });

  group('LogoutCubit', () {
    test('initial state should be LogoutInitial', () {
      expect(sut.state, isA<LogoutInitial>());
    });
    blocTest<LogoutCubit, LogoutState>(
      'emits [LogoutLoading, LogoutSuccess] when logout succeeds',
      build: () {
        when(
          () => mockLogoutUseCase.call(),
        ).thenAnswer((_) async => const NetworkSuccess<String>('success'));
        return sut;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [isA<LogoutLoading>(), isA<LogoutSuccess>()],
      verify: (_) {
        verify(() => mockLogoutUseCase.call()).called(1);
        verifyNoMoreInteractions(mockLogoutUseCase);
      },
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits [LogoutLoading, LogoutFailure] when logout fails',
      build: () {
        when(() => mockLogoutUseCase.call()).thenAnswer(
          (_) async => NetworkFailure<String>(Exception('logout_failed')),
        );
        return sut;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutLoading>(),
        isA<LogoutFailure>().having(
          (failure) => failure.errorMessage,
          'errorMessage',
          'logout_failed',
        ),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase.call()).called(1);
        verifyNoMoreInteractions(mockLogoutUseCase);
      },
    );
  });
}
