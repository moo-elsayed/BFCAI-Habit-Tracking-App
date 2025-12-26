import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/register_cubit/register_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockRegisterInputEntity extends Mock implements RegisterInputEntity {}

void main() {
  late RegisterCubit sut;
  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterInputEntity input;

  setUpAll(() {
    registerFallbackValue(MockRegisterInputEntity());

    input = RegisterInputEntity(
      fullName: 'John Doe',
      username: 'johndoe',
      email: 'john@mail.com',
      password: 'password',
      confirmPassword: 'password',
    );
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    sut = RegisterCubit(mockRegisterUseCase);
  });

  tearDown(() async {
    await sut.close();
  });

  group('RegisterCubit', () {
    test('initial state should be RegisterInitial', () {
      expect(sut.state, isA<RegisterInitial>());
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] when register succeeds',
      build: () {
        when(
          () => mockRegisterUseCase.call(input),
        ).thenAnswer((_) async => const NetworkSuccess<String>('success'));
        return sut;
      },
      act: (cubit) => cubit.register(input),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
      verify: (_) {
        verify(() => mockRegisterUseCase.call(input)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits [RegisterLoading, RegisterFailure] when register fails',
      build: () {
        when(() => mockRegisterUseCase.call(input)).thenAnswer(
          (_) async => NetworkFailure<String>(Exception('register_failed')),
        );
        return sut;
      },
      act: (cubit) => cubit.register(input),
      expect: () => [
        isA<RegisterLoading>(),
        isA<RegisterFailure>().having(
          (failure) => failure.errorMessage,
          'errorMessage',
          'register_failed',
        ),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase.call(input)).called(1);
      },
    );
  });
}
