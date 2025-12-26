import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/services/database_service/query_parameters.dart';
import 'package:habit_tracking_app/shared_data/services/database_service/api_database_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiDatabaseService sut;
  late MockDio mockDio;

  const path = '/test';

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = .new();
    sut = .new(mockDio);
  });

  group('ApiDatabaseService', () {
    test("should return success message when add data is successful", () async {
      // Arrange
      when(() => mockDio.post(path, data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: {"succeeded": true, "data": "success", "message": "success"},
          statusCode: 200,
        ),
      );
      // Act
      final result = await sut.addData(path: path, data: {"name": "test"});
      // Assert
      expect(result, 'success');
      verify(() => mockDio.post(path, data: any(named: 'data'))).called(1);
    });
    test(
      "should return success message when delete data is successful",
      () async {
        // Arrange
        when(() => mockDio.delete('$path/1')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: path),
            data: {"succeeded": true, "data": "success", "message": "success"},
            statusCode: 200,
          ),
        );
        // Act
        final result = await sut.deleteData(path: path, id: 1);
        // Assert
        expect(result, 'success');
        verify(() => mockDio.delete('$path/1')).called(1);
      },
    );
    test(
      "should return list of maps when get all data is successful",
      () async {
        // Arrange
        when(() => mockDio.get(path)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: path),
            data: {
              "succeeded": true,
              "data": [
                {"id": 1, "name": "test1"},
                {"id": 2, "name": "test2"},
              ],
              "message": "success",
            },
            statusCode: 200,
          ),
        );
        // Act
        final result = await sut.getAllData(path);
        // Assert
        expect(result, [
          {"id": 1, "name": "test1"},
          {"id": 2, "name": "test2"},
        ]);
        verify(() => mockDio.get(path)).called(1);
      },
    );
    test("should return map when get data is successful", () async {
      // Arrange
      when(() => mockDio.get('$path/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: {
            "succeeded": true,
            "data": {"id": 1, "name": "test"},
            "message": "success",
          },
          statusCode: 200,
        ),
      );
      // Act
      final result = await sut.getData(path: path, id: '1');
      // Assert
      expect(result, {"id": 1, "name": "test"});
      verify(() => mockDio.get('$path/1')).called(1);
    });

    test(
      "should return success message when update data is successful",
      () async {
        // Arrange
        when(
          () => mockDio.put(
            path,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: path),
            data: {"succeeded": true, "data": "success", "message": "success"},
            statusCode: 200,
          ),
        );
        // Act
        final result = await sut.updateData(
          path: path,
          data: {"name": "test"},
          params: QueryParameters(
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            habitId: 50,
          ).toJson(),
        );
        // Assert
        expect(result, 'success');
        verify(
          () => mockDio.put(
            path,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test("should return list of maps when query data is successful", () async {
      // Arrange
      when(
        () => mockDio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
          data: {
            "succeeded": true,
            "data": [
              {"id": 1, "name": "test1"},
              {"id": 2, "name": "test2"},
            ],
            "message": "success",
          },
          statusCode: 200,
        ),
      );
      // Act
      final result = await sut.queryData(
        path: path,
        query: QueryParameters(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          habitId: 50,
        ),
      );
      // Assert
      expect(result, [
        {"id": 1, "name": "test1"},
        {"id": 2, "name": "test2"},
      ]);
      verify(
        () => mockDio.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
    });
  });
}
