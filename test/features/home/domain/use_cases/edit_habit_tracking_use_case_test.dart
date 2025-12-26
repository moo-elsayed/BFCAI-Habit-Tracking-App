import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/edit_habit_tracking_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

class MockEditHabitTrackingInputEntity extends Mock
    implements EditHabitTrackingInputEntity {}

void main() {
  late EditHabitTrackingUseCase sut;
  late MockHomeRepo mockHomeRepo;
  late EditHabitTrackingInputEntity input;

  setUpAll(() {
    registerFallbackValue(MockEditHabitTrackingInputEntity());

    input = const .new(trackingId: 1, currentValue: 2);
  });

  setUp(() {
    mockHomeRepo = .new();
    sut = .new(mockHomeRepo);
  });

  group('EditHabitTrackingUseCase', () {
    test(
      'should return NetworkSuccess<String> when repo call succeeds',
      () async {
        // Arrange
        when(
          () => mockHomeRepo.editHabitTracking(input),
        ).thenAnswer((_) async => const NetworkSuccess<String>('success'));

        // Act
        final result = await sut.call(input);

        // Assert
        expect(result, isA<NetworkSuccess<String>>());
        expect((result as NetworkSuccess<String>).data, 'success');

        verify(() => mockHomeRepo.editHabitTracking(input)).called(1);
        verifyNoMoreInteractions(mockHomeRepo);
      },
    );

    test('should return NetworkFailure<String> when repo call fails', () async {
      // Arrange
      when(
        () => mockHomeRepo.editHabitTracking(input),
      ).thenAnswer((_) async => NetworkFailure<String>(Exception('error')));

      // Act
      final result = await sut.call(input);

      // Assert
      expect(result, isA<NetworkFailure<String>>());
      expect(getErrorMessage(result), 'error');
      verify(() => mockHomeRepo.editHabitTracking(input)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });
  });
}
