import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/confirm_email_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockConfirmEmailInputEntity extends Mock
    implements ConfirmEmailInputEntity {}

void main() {
  late ConfirmEmailUseCase sut;
  late MockAuthRepo mockAuthRepo;
  late ConfirmEmailInputEntity input;

  setUpAll(() {
    registerFallbackValue(MockConfirmEmailInputEntity());

    input = .new(email: 'test@mail.com', code: '123456');
  });

  setUp(() {
    mockAuthRepo = .new();
    sut = .new(mockAuthRepo);
  });

  group('ConfirmEmailUseCase', () {
    test('should return NetworkSuccess when confirm email succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepo.confirmEmail(input),
      ).thenAnswer((_) async => const NetworkSuccess<String>('success'));

      // Act
      final result = await sut.call(input);

      // Assert
      expect(result, isA<NetworkSuccess<String>>());
      expect((result as NetworkSuccess).data, 'success');

      verify(() => mockAuthRepo.confirmEmail(input)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return NetworkFailure when confirm email fails', () async {
      // Arrange
      when(
        () => mockAuthRepo.confirmEmail(input),
      ).thenAnswer((_) async => NetworkFailure<String>(Exception('error')));

      // Act
      final result = await sut.call(input);

      // Assert
      expect(result, isA<NetworkFailure<String>>());
      expect(getErrorMessage(result), 'error');
      verify(() => mockAuthRepo.confirmEmail(input)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
