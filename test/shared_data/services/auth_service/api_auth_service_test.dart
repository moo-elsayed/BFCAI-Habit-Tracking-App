import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/shared_data/services/auth_service/api_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiAuthService sut;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = .new();
    sut = .new(mockDio);
  });

  group('ApiAuthService', () {
    test(
      "should returns success message when register is successful",
      () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.register),
            data: {"succeeded": true, "data": "success", "message": "success"},
            statusCode: 200,
          ),
        );
        final input = RegisterInputEntity(
          fullName: "Test User",
          username: 'test',
          email: 'test@test.com',
          password: '123456789',
          confirmPassword: "123456789",
        );
        // Act
        final result = await sut.register(input);
        // Assert
        expect(result, isA<String>());
        expect(result, 'success');
        verify(
          () => mockDio.post(ApiConstants.register, data: any(named: 'data')),
        ).called(1);
      },
    );

    test(
      'should return LoginResponseEntity when login is successful',
      () async {
        // Arrange
        when(
          () => mockDio.post(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.login),
            data: {
              "succeeded": true,
              "data": {
                "token": "access_token",
                "refreshToken": "refresh_token",
              },
              "message": "success",
            },
            statusCode: 200,
          ),
        );
        final input = LoginInputEntity(
          email: 'test@test.com',
          password: '123456',
        );
        // Act
        final result = await sut.login(input);
        // Assert
        expect(result, isA<LoginResponseEntity>());
        expect(result.token, 'access_token');
        expect(result.refreshToken, 'refresh_token');
        verify(
          () => mockDio.post(
            ApiConstants.login,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test("should return success when confirm email is successful", () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.confirmEmail),
          data: {
            "succeeded": true,
            "data": "email confirmed",
            "message": "success",
          },
          statusCode: 200,
        ),
      );
      final input = ConfirmEmailInputEntity(
        email: 'test@test.com',
        code: '123456',
      );
      // Act
      final result = await sut.confirmEmail(input);
      // Assert
      expect(result, isA<String>());
      expect(result, 'email confirmed');
      verify(
        () => mockDio.get(
          ApiConstants.confirmEmail,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);
    });

    test("should return success when logout is successful", () async {
      // Arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.revokeToken),
          data: {"succeeded": true, "data": "success", "message": "success"},
          statusCode: 200,
        ),
      );
      // Act
      final result = await sut.logout("refresh_token");
      // Assert
      expect(result, isA<String>());
      expect(result, 'success');
      verify(
        () => mockDio.post(
          ApiConstants.revokeToken,
          data: {"token": "refresh_token"},
        ),
      ).called(1);
    });
  });
}
