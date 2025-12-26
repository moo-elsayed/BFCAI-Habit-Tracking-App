import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/confirm_email_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/confirm_email_cubit/confirm_email_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockConfirmEmailUseCase extends Mock implements ConfirmEmailUseCase {}

class MockConfirmEmailInputEntity extends Mock
    implements ConfirmEmailInputEntity {}

void main() {
  late ConfirmEmailCubit sut;
  late MockConfirmEmailUseCase mockConfirmEmailUseCase;
  late ConfirmEmailInputEntity mockConfirmEmailInputEntity;

  setUpAll(() {
    registerFallbackValue(MockConfirmEmailInputEntity());
    mockConfirmEmailInputEntity = .new(email: 'test@mail.com', code: '123456');
  });

  setUp(() {
    mockConfirmEmailUseCase = .new();
    sut = .new(mockConfirmEmailUseCase);
  });

  tearDown(() {
    sut.close();
  });

  group('ConfirmEmailCubit', () {
    test('initial state should be ConfirmEmailInitial', () {
      expect(sut.state, isA<ConfirmEmailInitial>());
    });

    blocTest(
      'should emit ConfirmEmailSuccess when confirmEmail succeeds',
      build: () => sut,
      setUp: () {
        when(
          () => mockConfirmEmailUseCase.call(mockConfirmEmailInputEntity),
        ).thenAnswer((_) async => const NetworkSuccess<String>('success'));
      },
      act: (cubit) => cubit.confirmEmail(mockConfirmEmailInputEntity),
      expect: () => [isA<ConfirmEmailLoading>(), isA<ConfirmEmailSuccess>()],
      verify: (_) {
        verify(
          () => mockConfirmEmailUseCase.call(mockConfirmEmailInputEntity),
        ).called(1);
        verifyNoMoreInteractions(mockConfirmEmailUseCase);
      },
    );

    blocTest(
      "should emit ConfirmEmailFailure when confirmEmail fails",
      build: () => sut,
      setUp: () {
        when(
          () => mockConfirmEmailUseCase.call(mockConfirmEmailInputEntity),
        ).thenAnswer((_) async => NetworkFailure<String>(Exception('error')));
      },
      act: (cubit) => cubit.confirmEmail(mockConfirmEmailInputEntity),
      expect: () => [
        isA<ConfirmEmailLoading>(),
        isA<ConfirmEmailFailure>().having(
          (failure) => failure.errorMessage,
          'errorMessage',
          'error',
        ),
      ],
      verify: (_) {
        verify(
          () => mockConfirmEmailUseCase.call(mockConfirmEmailInputEntity),
        ).called(1);
        verifyNoMoreInteractions(mockConfirmEmailUseCase);
      },
    );
  });
}
