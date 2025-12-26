import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/core/helpers/enums.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source_imp.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late HomeRemoteDataSourceImp sut;
  late MockDatabaseService mockDatabaseService;
  late CreateHabitTrackingInputEntity createHabitTrackingInputEntity;
  late EditHabitTrackingInputEntity editHabitTrackingInputEntity;

  setUpAll(() {
    createHabitTrackingInputEntity = .new(
      habitId: 1,
      date: DateTime(2024, 1, 1),
      currentValue: 1,
    );
    editHabitTrackingInputEntity = const .new(currentValue: 2, trackingId: 10);
  });

  setUp(() {
    mockDatabaseService = .new();
    sut = .new(mockDatabaseService);
  });

  group("HomeRemoteDataSourceImp", () {
    group("getAllHabits", () {
      test(
        "should return NetworkSuccess<List<HabitEntity>> when database call succeeds",
        () async {
          // Arrange
          final mockResponse = [
            {
              "id": 1,
              "name": "Drink Water",
              "type": "UnCountableHabit",
              "targetValue": 8,
              "isActive": true,
              "startDate": "2024-01-01",
              "color": "0xFF2196F3",
              "icon": "57410",
              "habitSchedules": [],
            },
          ];
          when(
            () => mockDatabaseService.getAllData(any()),
          ).thenAnswer((_) async => mockResponse);
          // Act
          final result = await sut.getAllHabits();
          // Assert
          expect(result, isA<NetworkSuccess<List<HabitEntity>>>());
          final habits = (result as NetworkSuccess<List<HabitEntity>>).data;
          expect(habits, isNotEmpty);
          expect(habits?.first.name, 'Drink Water');
          expect(habits?.first.type, HabitType.task);
          expect(habits?.first.targetValue, 8);
          verify(
            () => mockDatabaseService.getAllData(ApiConstants.getAllHabits),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<List<HabitEntity>> when database call throws dio exception",
        () async {
          // Arrange
          when(() => mockDatabaseService.getAllData(any())).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionError,
            ),
          );
          // Act
          final result = await sut.getAllHabits();
          // Assert
          expect(result, isA<NetworkFailure<List<HabitEntity>>>());
          expect(getErrorMessage(result), 'no_internet_connection');
          verify(() => mockDatabaseService.getAllData(any())).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<List<HabitEntity>> when database call throws exception",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.getAllData(any()),
          ).thenThrow(Exception('Some error'));
          // Act
          final result = await sut.getAllHabits();
          // Assert
          expect(result, isA<NetworkFailure<List<HabitEntity>>>());
          expect(getErrorMessage(result), 'Some error');
          verify(() => mockDatabaseService.getAllData(any())).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
    });
    group("createHabitTracking", () {
      test(
        "should return NetworkSuccess<int> when database call succeeds",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.addData(
              path: any(named: 'path'),
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => '1');
          // Act
          final result = await sut.createHabitTracking(
            createHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkSuccess<int>>());
          expect((result as NetworkSuccess<int>).data, 1);
          verify(
            () => mockDatabaseService.addData(
              path: ApiConstants.createHabitTracking,
              data: any(named: 'data'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<int> when database call throws dio exception",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.addData(
              path: any(named: 'path'),
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .badCertificate,
            ),
          );
          // Act
          final result = await sut.createHabitTracking(
            createHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkFailure<int>>());
          expect(getErrorMessage(result), 'bad_certificate');
          verify(
            () => mockDatabaseService.addData(
              path: ApiConstants.createHabitTracking,
              data: any(named: 'data'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<int> when database call throws exception",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.addData(
              path: any(named: 'path'),
              data: any(named: 'data'),
            ),
          ).thenThrow(Exception('Some error'));
          // Act
          final result = await sut.createHabitTracking(
            createHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkFailure<int>>());
          expect(getErrorMessage(result), 'Some error');
          verify(
            () => mockDatabaseService.addData(
              path: ApiConstants.createHabitTracking,
              data: any(named: 'data'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
    });
    group("editHabitTracking", () {
      test(
        "should return NetworkSuccess<String> when database call succeeds",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: any(named: 'path'),
              params: any(named: 'params'),
            ),
          ).thenAnswer((_) async => 'success');
          // Act
          final result = await sut.editHabitTracking(
            editHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkSuccess<String>>());
          expect((result as NetworkSuccess<String>).data, 'success');
          verify(
            () => mockDatabaseService.updateData(
              path: ApiConstants.editHabitTracking,
              params: any(named: 'params'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<String> when database call throws dio exception",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: any(named: 'path'),
              params: any(named: 'params'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .badCertificate,
            ),
          );
          // Act
          final result = await sut.editHabitTracking(
            editHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkFailure<String>>());
          expect(getErrorMessage(result), 'bad_certificate');
          verify(
            () => mockDatabaseService.updateData(
              path: ApiConstants.editHabitTracking,
              params: any(named: 'params'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<String> when database call throws exception",
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: any(named: 'path'),
              params: any(named: 'params'),
            ),
          ).thenThrow(Exception('Some error'));
          // Act
          final result = await sut.editHabitTracking(
            editHabitTrackingInputEntity,
          );
          // Assert
          expect(result, isA<NetworkFailure<String>>());
          expect(getErrorMessage(result), 'Some error');
          verify(
            () => mockDatabaseService.updateData(
              path: ApiConstants.editHabitTracking,
              params: any(named: 'params'),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
    });
    group("getHabitsByDate", () {
      test(
        "should return NetworkSuccess<List<HabitTrackingEntity>> when database call succeeds",
        () async {
          // Arrange
          final date = DateTime(2024, 1, 15);

          final mockResponse = [
            {
              "habitId": 10,
              "habitName": "Drink Water",
              "habitType": "CountableHabit",
              "habitTargetValue": 8,
              "habitIcon": "57410",
              "habitColor": "0xFF2196F3",
              "isActive": true,
              "trackingRecord": {
                "id": 101,
                "status": "completed",
                "currentValue": 5,
                "progressPercentage": 62.5,
                "updatedAt": "2024-01-15T10:30:00Z",
              },
            },
            {
              "habitId": 11,
              "habitName": "Read Book",
              "habitType": "UnCountableHabit",
              "habitTargetValue": 1,
              "habitIcon": "57401",
              "habitColor": "0xFFFF5722",
              "isActive": true,
              "trackingRecord": {
                "id": 102,
                "status": "pending",
                "currentValue": 0,
                "progressPercentage": 0,
                "updatedAt": "2024-01-15T08:00:00Z",
              },
            },
          ];
          when(
            () => mockDatabaseService.getAllData(any()),
          ).thenAnswer((_) async => mockResponse);
          // Act
          final result = await sut.getHabitsByDate(date);
          // Assert
          expect(result, isA<NetworkSuccess<List<HabitTrackingEntity>>>());
          final habits =
              (result as NetworkSuccess<List<HabitTrackingEntity>>).data;

          expect(habits, isNotEmpty);
          expect(habits?.first.trackingRecordEntity.trackingId, 101);
          verify(
            () => mockDatabaseService.getAllData(
              "${ApiConstants.getHabitsByDate}/${date.toIsoDate}",
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<List<HabitTrackingEntity>> when database call throws dio exception",
        () async {
          // Arrange
          final date = DateTime(2024, 1, 15);
          when(() => mockDatabaseService.getAllData(any())).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionError,
            ),
          );
          // Act
          final result = await sut.getHabitsByDate(date);
          // Assert
          expect(result, isA<NetworkFailure<List<HabitTrackingEntity>>>());
          expect(getErrorMessage(result), 'no_internet_connection');
          verify(
            () => mockDatabaseService.getAllData(
              "${ApiConstants.getHabitsByDate}/${date.toIsoDate}",
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
      test(
        "should return NetworkFailure<List<HabitTrackingEntity>> when database call throws exception",
        () async {
          // Arrange
          final date = DateTime(2024, 1, 15);
          when(
            () => mockDatabaseService.getAllData(any()),
          ).thenThrow(Exception('Some error'));
          // Act
          final result = await sut.getHabitsByDate(date);
          // Assert
          expect(result, isA<NetworkFailure<List<HabitTrackingEntity>>>());
          expect(getErrorMessage(result), 'Some error');
          verify(
            () => mockDatabaseService.getAllData(
              "${ApiConstants.getHabitsByDate}/${date.toIsoDate}",
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDatabaseService);
        },
      );
    });
  });
}
