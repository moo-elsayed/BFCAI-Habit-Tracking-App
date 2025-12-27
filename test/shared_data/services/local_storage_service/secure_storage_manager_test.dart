// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:habit_tracking_app/shared_data/services/local_storage_service/secure_storage_manager.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
//
// void main() {
//   late SecureStorageManager sut;
//   late MockFlutterSecureStorage mockFlutterSecureStorage;
//
//   setUp(() {
//     mockFlutterSecureStorage = .new();
//     sut = .new(mockFlutterSecureStorage);
//   });
//
//   group('SecureStorageManager', () {
//     test("should write both tokens to storage", () async {
//       // Arrange
//       when(
//         () => mockFlutterSecureStorage.write(
//           key: any(named: 'key'),
//           value: any(named: 'value'),
//         ),
//       ).thenAnswer((_) async {});
//       // Act
//       await sut.saveTokens(
//         accessToken: 'accessToken',
//         refreshToken: 'refreshToken',
//       );
//       // Assert
//       verify(
//         () => mockFlutterSecureStorage.write(
//           key: 'accessToken',
//           value: 'accessToken',
//         ),
//       ).called(1);
//       verify(
//         () => mockFlutterSecureStorage.write(
//           key: 'refreshToken',
//           value: 'refreshToken',
//         ),
//       ).called(1);
//     });
//     test("should return access token from storage", () async {
//       // Arrange
//       when(
//         () => mockFlutterSecureStorage.read(key: 'accessToken'),
//       ).thenAnswer((_) async => 'accessToken');
//       // Act
//       final accessToken = await sut.getAccessToken();
//       // Assert
//       expect(accessToken, 'accessToken');
//       verify(() => mockFlutterSecureStorage.read(key: 'accessToken')).called(1);
//       verifyNoMoreInteractions(mockFlutterSecureStorage);
//     });
//
//     test("should return refresh token from storage", () async {
//       // Arrange
//       when(
//         () => mockFlutterSecureStorage.read(key: 'refreshToken'),
//       ).thenAnswer((_) async => 'refreshToken');
//       // Act
//       final refreshToken = await sut.getRefreshToken();
//       // Assert
//       expect(refreshToken, 'refreshToken');
//       verify(
//         () => mockFlutterSecureStorage.read(key: 'refreshToken'),
//       ).called(1);
//       verifyNoMoreInteractions(mockFlutterSecureStorage);
//     });
//
//     test("should clear all stored values", () async {
//       // Arrange
//       when(() => mockFlutterSecureStorage.deleteAll()).thenAnswer((_) async {});
//       // Act
//       await sut.clearTokens();
//       // Assert
//       verify(() => mockFlutterSecureStorage.deleteAll()).called(1);
//       verifyNoMoreInteractions(mockFlutterSecureStorage);
//     });
//   });
// }
