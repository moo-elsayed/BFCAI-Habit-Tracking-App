import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_all_habits_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late GetAllHabitsUseCase sut;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = .new();
    sut = .new(mockHomeRepo);
  });

  group('GetAllHabitsUseCase', () {
    test(
      'should return NetworkSuccess<List<HabitEntity>> when repo call succeeds',
      () async {
        // Arrange
        when(
          () => mockHomeRepo.getAllHabits(),
        ).thenAnswer((_) async => const NetworkSuccess<List<HabitEntity>>([]));

        // Act
        final result = await sut.call();

        // Assert
        expect(result, isA<NetworkSuccess<List<HabitEntity>>>());
        verify(() => mockHomeRepo.getAllHabits()).called(1);
        verifyNoMoreInteractions(mockHomeRepo);
      },
    );

    test(
      'should return NetworkFailure<List<HabitEntity>> when repo call fails',
      () async {
        // Arrange
        when(() => mockHomeRepo.getAllHabits()).thenAnswer(
          (_) async => NetworkFailure<List<HabitEntity>>(Exception('error')),
        );

        // Act
        final result = await sut.call();

        // Assert
        expect(result, isA<NetworkFailure<List<HabitEntity>>>());
        expect(getErrorMessage(result), 'error');
        verify(() => mockHomeRepo.getAllHabits()).called(1);
        verifyNoMoreInteractions(mockHomeRepo);
      },
    );
  });
}
