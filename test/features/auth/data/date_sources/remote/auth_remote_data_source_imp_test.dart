import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/auth_service/auth_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
import 'package:habit_tracking_app/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthStorageService extends Mock implements AuthStorageService {}

class MockRegisterInputEntity extends Mock implements RegisterInputEntity {}

class MockLoginInputEntity extends Mock implements LoginInputEntity {}

class MockConfirmEmailInputEntity extends Mock
    implements ConfirmEmailInputEntity {}

void main() {
  late AuthRemoteDataSourceImp sut;
  late MockAuthService mockAuthService;
  late MockAuthStorageService mockAuthStorageService;
  late RegisterInputEntity registerInput;
  late LoginInputEntity loginInput;
  late ConfirmEmailInputEntity confirmEmailInput;

  setUpAll(() {
    registerFallbackValue(MockRegisterInputEntity());
    registerFallbackValue(MockLoginInputEntity());
    registerFallbackValue(MockConfirmEmailInputEntity());

    registerInput = .new(
      fullName: "John Doe",
      username: "johndoe",
      email: "william.henry.moody@my-own-personal-domain.com",
      password: "password",
      confirmPassword: "password",
    );

    loginInput = .new(email: "kddkd@gmail.com", password: "password");

    confirmEmailInput = .new(email: "kddkd@gmail.com", code: "123456");
  });

  setUp(() {
    mockAuthService = .new();
    mockAuthStorageService = .new();
    sut = .new(mockAuthService, mockAuthStorageService);
  });

  group("AuthRemoteDataSourceImp", () {
    group("register", () {
      test(
        "should return network success when register is successful",
        () async {
          // Arrange
          when(
            () => mockAuthService.register(registerInput),
          ).thenAnswer((_) async => "success");
          // Act
          final result = await sut.register(registerInput);
          // Assert
          expect(result, isA<NetworkSuccess>());
          expect((result as NetworkSuccess).data, "success");
          verify(() => mockAuthService.register(registerInput)).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test(
        "should return network failure when register fails with dio exception",
        () async {
          // Arrange
          when(() => mockAuthService.register(registerInput)).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionError,
            ),
          );
          // Act
          final result = await sut.register(registerInput);
          // Assert
          expect(result, isA<NetworkFailure>());
          expect(getErrorMessage(result), "no_internet_connection");
          verify(() => mockAuthService.register(registerInput)).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test("should return network failure when register fails", () async {
        // Arrange
        when(
          () => mockAuthService.register(registerInput),
        ).thenThrow(Exception("error"));
        // Act
        final result = await sut.register(registerInput);
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), "error");
        verify(() => mockAuthService.register(registerInput)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });
    group("login", () {
      test("should return network success when login is successful", () async {
        // Arrange
        when(() => mockAuthService.login(loginInput)).thenAnswer(
          (_) async => LoginResponseEntity(
            email: "kddkd@gmail.com",
            username: "johndoe",
            token: "access_token",
            refreshToken: "refresh_token",
            roles: ["user"],
          ),
        );
        // Act
        final result = await sut.login(loginInput);
        // Assert
        expect(result, isA<NetworkSuccess>());
        expect((result as NetworkSuccess).data.email, "kddkd@gmail.com");
        verify(() => mockAuthService.login(loginInput)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
      test(
        "should return network failure when login fails with dio exception",
        () async {
          // Arrange
          when(() => mockAuthService.login(loginInput)).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionError,
            ),
          );
          // Act
          final result = await sut.login(loginInput);
          // Assert
          expect(result, isA<NetworkFailure>());
          expect(getErrorMessage(result), "no_internet_connection");
          verify(() => mockAuthService.login(loginInput)).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test("should return network failure when login fails", () async {
        // Arrange
        when(
          () => mockAuthService.login(loginInput),
        ).thenThrow(Exception("error"));
        // Act
        final result = await sut.login(loginInput);
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), "error");
        verify(() => mockAuthService.login(loginInput)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });
    group("confirmEmail", () {
      test(
        "should return network success when confirmEmail is successful",
        () async {
          // Arrange
          when(
            () => mockAuthService.confirmEmail(confirmEmailInput),
          ).thenAnswer((_) async => "success");
          // Act
          final result = await sut.confirmEmail(confirmEmailInput);
          // Assert
          expect(result, isA<NetworkSuccess>());
          expect((result as NetworkSuccess).data, "success");
          verify(
            () => mockAuthService.confirmEmail(confirmEmailInput),
          ).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test(
        "should return network failure when confirmEmail fails with dio exception",
        () async {
          // Arrange
          when(() => mockAuthService.confirmEmail(confirmEmailInput)).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionTimeout,
            ),
          );
          // Act
          final result = await sut.confirmEmail(confirmEmailInput);
          // Assert
          expect(result, isA<NetworkFailure>());
          expect(getErrorMessage(result), "connection_timeout");
          verify(
            () => mockAuthService.confirmEmail(confirmEmailInput),
          ).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test("should return network failure when confirmEmail fails", () async {
        // Arrange
        when(
          () => mockAuthService.confirmEmail(confirmEmailInput),
        ).thenThrow(Exception("error"));
        // Act
        final result = await sut.confirmEmail(confirmEmailInput);
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), "error");
        verify(() => mockAuthService.confirmEmail(confirmEmailInput)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });
    group("logout", () {
      test("should return network success when logout is successful", () async {
        // Arrange
        when(
          () => mockAuthStorageService.getRefreshToken(),
        ).thenAnswer((_) async => "refresh_token");
        when(
          () => mockAuthService.logout("refresh_token"),
        ).thenAnswer((_) async => "success");
        // Act
        final result = await sut.logout();
        // Assert
        expect(result, isA<NetworkSuccess>());
        expect((result as NetworkSuccess).data, "success");
        verify(() => mockAuthStorageService.getRefreshToken()).called(1);
        verify(() => mockAuthService.logout("refresh_token")).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
      test("should return network failure when token is null", () async {
        // Arrange
        when(
          () => mockAuthStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);
        //
        final result = await sut.logout();
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), "token is null");
        verify(() => mockAuthStorageService.getRefreshToken()).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
      test(
        "should return network failure when logout fails with dio exception",
        () async {
          // Arrange
          when(
            () => mockAuthStorageService.getRefreshToken(),
          ).thenAnswer((_) async => "refresh_token");
          when(() => mockAuthService.logout("refresh_token")).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: .connectionError,
            ),
          );
          // Act
          final result = await sut.logout();
          // Assert
          expect(result, isA<NetworkFailure>());
          expect(getErrorMessage(result), "no_internet_connection");
          verify(() => mockAuthStorageService.getRefreshToken()).called(1);
          verify(() => mockAuthService.logout("refresh_token")).called(1);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
      test("should return network failure when logout fails", () async {
        // Arrange
        when(
          () => mockAuthStorageService.getRefreshToken(),
        ).thenAnswer((_) async => "refresh_token");
        when(
          () => mockAuthService.logout("refresh_token"),
        ).thenThrow(Exception("error"));
        //
        final result = await sut.logout();
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), "error");
        verify(() => mockAuthStorageService.getRefreshToken()).called(1);
        verify(() => mockAuthService.logout("refresh_token")).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });
  });
}
