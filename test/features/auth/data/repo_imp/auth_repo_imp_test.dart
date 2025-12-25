import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:habit_tracking_app/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockRegisterInputEntity extends Mock implements RegisterInputEntity {}

class MockLoginInputEntity extends Mock implements LoginInputEntity {}

class MockConfirmEmailInputEntity extends Mock
    implements ConfirmEmailInputEntity {}

void main() {
  late AuthRepoImp sut;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
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
    mockAuthRemoteDataSource = .new();
    sut = .new(mockAuthRemoteDataSource);
  });

  group("AuthRepoImp", () {
    group("register", () {
      test("should call register method from remote data source", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.register(registerInput),
        ).thenAnswer((_) async => const NetworkSuccess<String>("success"));
        // Act
        var networkResponse = await sut.register(registerInput);
        // Assert
        expect(networkResponse, isA<NetworkSuccess>());
        expect((networkResponse as NetworkSuccess).data, "success");
        verify(
          () => mockAuthRemoteDataSource.register(registerInput),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
      test("should return network failure when register fails", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.register(registerInput),
        ).thenAnswer((_) async => NetworkFailure<String>(Exception("error")));
        // Act
        var networkResponse = await sut.register(registerInput);
        // Assert
        expect(networkResponse, isA<NetworkFailure>());
        expect(getErrorMessage(networkResponse), "error");
        verify(
          () => mockAuthRemoteDataSource.register(registerInput),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });
    group("login", () {
      test("should call login method from remote data source", () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.login(loginInput)).thenAnswer(
          (_) async => NetworkSuccess<LoginResponseEntity>(
            LoginResponseEntity(
              email: "kddkd@gmail.com",
              username: "johndoe",
              token: "access_token",
              refreshToken: "refresh_token",
              roles: ["user"],
            ),
          ),
        );
        // Act
        var networkResponse = await sut.login(loginInput);
        // Assert
        expect(networkResponse, isA<NetworkSuccess>());
        expect(
          (networkResponse as NetworkSuccess).data.email,
          "kddkd@gmail.com",
        );
        verify(() => mockAuthRemoteDataSource.login(loginInput)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
      test("should return network failure when login fails", () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.login(loginInput)).thenAnswer(
          (_) async => NetworkFailure<LoginResponseEntity>(Exception("error")),
        );
        // Act
        var networkResponse = await sut.login(loginInput);
        // Assert
        expect(networkResponse, isA<NetworkFailure>());
        expect(getErrorMessage(networkResponse), "error");
        verify(() => mockAuthRemoteDataSource.login(loginInput)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });
    group("confirmEmail", () {
      test("should call confirmEmail method from remote data source", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.confirmEmail(confirmEmailInput),
        ).thenAnswer((_) async => const NetworkSuccess<String>("success"));
        // Act
        var networkResponse = await sut.confirmEmail(confirmEmailInput);
        // Assert
        expect(networkResponse, isA<NetworkSuccess>());
        expect((networkResponse as NetworkSuccess).data, "success");
        verify(
          () => mockAuthRemoteDataSource.confirmEmail(confirmEmailInput),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
      test("should return network failure when confirmEmail fails", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.confirmEmail(confirmEmailInput),
        ).thenAnswer((_) async => NetworkFailure<String>(Exception("error")));
        // Act
        var networkResponse = await sut.confirmEmail(confirmEmailInput);
        // Assert
        expect(networkResponse, isA<NetworkFailure>());
        expect(getErrorMessage(networkResponse), "error");
        verify(
          () => mockAuthRemoteDataSource.confirmEmail(confirmEmailInput),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });
    group("logout", () {
      test("should call logout method from remote data source", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.logout(),
        ).thenAnswer((_) async => const NetworkSuccess<String>("success"));
        // Act
        var networkResponse = await sut.logout();
        // Assert
        expect(networkResponse, isA<NetworkSuccess>());
        expect((networkResponse as NetworkSuccess).data, "success");
        verify(() => mockAuthRemoteDataSource.logout()).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
      test("should return network failure when logout fails", () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.logout(),
        ).thenAnswer((_) async => NetworkFailure<String>(Exception("error")));
        // Act
        var networkResponse = await sut.logout();
        // Assert
        expect(networkResponse, isA<NetworkFailure>());
        expect(getErrorMessage(networkResponse), "error");
        verify(() => mockAuthRemoteDataSource.logout()).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });
  });
}
