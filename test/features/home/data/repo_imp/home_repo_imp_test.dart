import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source.dart';
import 'package:habit_tracking_app/features/home/data/repo_imp/home_repo_imp.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

class MockCreateHabitTrackingInputEntity extends Mock
    implements CreateHabitTrackingInputEntity {}

class MockEditHabitTrackingInputEntity extends Mock
    implements EditHabitTrackingInputEntity {}

void main() {
  late HomeRepoImp sut;
  late MockHomeRemoteDataSource mockRemote;

  setUpAll(() {
    registerFallbackValue(MockCreateHabitTrackingInputEntity());
    registerFallbackValue(MockEditHabitTrackingInputEntity());
  });

  setUp(() {
    mockRemote = .new();
    sut = .new(mockRemote);
  });

  group('HomeRepoImp', () {
    test('getAllHabits should forward call to remote data source', () async {
      // Arrange
      when(
        () => mockRemote.getAllHabits(),
      ).thenAnswer((_) async => const NetworkSuccess<List<HabitEntity>>([]));

      // Act
      final result = await sut.getAllHabits();

      // Assert
      expect(result, isA<NetworkSuccess<List<HabitEntity>>>());
      verify(() => mockRemote.getAllHabits()).called(1);
      verifyNoMoreInteractions(mockRemote);
    });

    test('getHabitsByDate should forward call to remote data source', () async {
      // Arrange
      final date = DateTime(2024, 1, 1);

      when(() => mockRemote.getHabitsByDate(date)).thenAnswer(
        (_) async => const NetworkSuccess<List<HabitTrackingEntity>>([]),
      );

      // Act
      final result = await sut.getHabitsByDate(date);

      // Assert
      expect(result, isA<NetworkSuccess<List<HabitTrackingEntity>>>());
      verify(() => mockRemote.getHabitsByDate(date)).called(1);
      verifyNoMoreInteractions(mockRemote);
    });

    test(
      'createHabitTracking should forward call to remote data source',
      () async {
        // Arrange
        final input = CreateHabitTrackingInputEntity(
          habitId: 1,
          date: DateTime(2024, 1, 1),
          currentValue: 1,
        );

        when(
          () => mockRemote.createHabitTracking(input),
        ).thenAnswer((_) async => const NetworkSuccess<int>(1));

        // Act
        final result = await sut.createHabitTracking(input);

        // Assert
        expect(result, isA<NetworkSuccess<int>>());
        verify(() => mockRemote.createHabitTracking(input)).called(1);
        verifyNoMoreInteractions(mockRemote);
      },
    );

    test(
      'editHabitTracking should forward call to remote data source',
      () async {
        // Arrange
        final input = const EditHabitTrackingInputEntity(
          trackingId: 1,
          currentValue: 2,
        );

        when(
          () => mockRemote.editHabitTracking(input),
        ).thenAnswer((_) async => const NetworkSuccess<String>('success'));

        // Act
        final result = await sut.editHabitTracking(input);

        // Assert
        expect(result, isA<NetworkSuccess<String>>());
        verify(() => mockRemote.editHabitTracking(input)).called(1);
        verifyNoMoreInteractions(mockRemote);
      },
    );
  });
}
