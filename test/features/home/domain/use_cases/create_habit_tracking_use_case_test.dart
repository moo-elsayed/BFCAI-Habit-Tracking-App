import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/create_habit_tracking_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

class MockCreateHabitTrackingInputEntity extends Mock
    implements CreateHabitTrackingInputEntity {}

void main() {
  late CreateHabitTrackingUseCase sut;
  late MockHomeRepo mockHomeRepo;
  late CreateHabitTrackingInputEntity input;

  setUpAll(() {
    registerFallbackValue(MockCreateHabitTrackingInputEntity());

    input = .new(
      habitId: 1,
      date: DateTime(2024, 1, 1),
      currentValue: 1,
    );
  });

  setUp(() {
    mockHomeRepo = .new();
    sut = .new(mockHomeRepo);
  });

  group('CreateHabitTrackingUseCase', () {
    test('should return NetworkSuccess<int> when repo call succeeds', () async {
      // Arrange
      when(
        () => mockHomeRepo.createHabitTracking(input),
      ).thenAnswer((_) async => const NetworkSuccess<int>(1));

      // Act
      final result = await sut.call(input);

      // Assert
      expect(result, isA<NetworkSuccess<int>>());
      expect((result as NetworkSuccess<int>).data, 1);

      verify(() => mockHomeRepo.createHabitTracking(input)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    test('should return NetworkFailure<int> when repo call fails', () async {
      // Arrange
      when(
        () => mockHomeRepo.createHabitTracking(input),
      ).thenAnswer((_) async => NetworkFailure<int>(Exception('error')));

      // Act
      final result = await sut.call(input);

      // Assert
      expect(result, isA<NetworkFailure<int>>());
      expect(getErrorMessage(result), 'error');
      verify(() => mockHomeRepo.createHabitTracking(input)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });
  });
}
