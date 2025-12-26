import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockRegisterInputEntity extends Mock
    implements RegisterInputEntity {}

void main() {
  late RegisterUseCase sut;
  late MockAuthRepo mockAuthRepo;
  late RegisterInputEntity registerInput;

  setUpAll(() {
    registerFallbackValue(MockRegisterInputEntity());

    registerInput = .new(
      fullName: 'John Doe',
      username: 'johndoe',
      email: 'john@mail.com',
      password: 'password',
      confirmPassword: 'password',
    );
  });

  setUp(() {
    mockAuthRepo = .new();
    sut = .new(mockAuthRepo);
  });

  group('RegisterUseCase', () {
    test(
      'should return NetworkSuccess when register succeeds',
          () async {
        // Arrange
        when(() => mockAuthRepo.register(registerInput))
            .thenAnswer((_) async => const NetworkSuccess<String>('success'));

        // Act
        final result = await sut.call(registerInput);

        // Assert
        expect(result, isA<NetworkSuccess<String>>());
        expect((result as NetworkSuccess).data, 'success');

        verify(() => mockAuthRepo.register(registerInput)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );

    test(
      'should return NetworkFailure when register fails',
          () async {
        // Arrange
        when(() => mockAuthRepo.register(registerInput))
            .thenAnswer(
              (_) async => NetworkFailure<String>(Exception('error')),
        );

        // Act
        final result = await sut.call(registerInput);

        // Assert
        expect(result, isA<NetworkFailure<String>>());
        expect(getErrorMessage(result), 'error');

        verify(() => mockAuthRepo.register(registerInput)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );
  });
}