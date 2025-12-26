import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_habits_by_date_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late GetHabitsByDateUseCase sut;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    sut = GetHabitsByDateUseCase(mockHomeRepo);
  });

  group('GetHabitsByDateUseCase', () {
    test(
      'should return NetworkSuccess<List<HabitTrackingEntity>> when repo call succeeds',
      () async {
        // Arrange
        final date = DateTime(2024, 1, 15);

        when(() => mockHomeRepo.getHabitsByDate(date)).thenAnswer(
          (_) async => const NetworkSuccess<List<HabitTrackingEntity>>([]),
        );

        // Act
        final result = await sut.call(date);

        // Assert
        expect(result, isA<NetworkSuccess<List<HabitTrackingEntity>>>());

        verify(() => mockHomeRepo.getHabitsByDate(date)).called(1);
        verifyNoMoreInteractions(mockHomeRepo);
      },
    );

    test(
      'should return NetworkFailure<List<HabitTrackingEntity>> when repo call fails',
      () async {
        // Arrange
        final date = DateTime(2024, 1, 15);

        when(() => mockHomeRepo.getHabitsByDate(date)).thenAnswer(
          (_) async =>
              NetworkFailure<List<HabitTrackingEntity>>(Exception('error')),
        );

        // Act
        final result = await sut.call(date);

        // Assert
        expect(result, isA<NetworkFailure<List<HabitTrackingEntity>>>());
        expect(getErrorMessage(result), 'error');
        verify(() => mockHomeRepo.getHabitsByDate(date)).called(1);
        verifyNoMoreInteractions(mockHomeRepo);
      },
    );
  });
}
