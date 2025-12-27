// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
// import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
// import 'package:habit_tracking_app/features/splash/presentation/managers/splash_cubit.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockAppPreferencesService extends Mock implements AppPreferencesService {}
//
// class MockAuthStorageService extends Mock implements AuthStorageService {}
//
// void main() {
//   late SplashCubit sut;
//   late MockAppPreferencesService mockAppPreferencesService;
//   late MockAuthStorageService mockAuthStorageService;
//
//   setUp(() {
//     mockAppPreferencesService = .new();
//     mockAuthStorageService = .new();
//     sut = .new(mockAppPreferencesService, mockAuthStorageService);
//   });
//
//   group('SplashCubit', () {
//     test('initial state should be SplashInitial', () {
//       expect(sut.state, isA<SplashInitial>());
//     });
//     blocTest(
//       'should emit SplashSuccess with navigateToOnboarding when checkAppStatus is called and _firstTime is true',
//       build: () => sut,
//       setUp: () {
//         when(() => mockAppPreferencesService.getFirstTime()).thenReturn(true);
//       },
//       act: (_) => sut.checkAppStatus(),
//       expect: () => [
//         isA<SplashSuccess>().having(
//           (success) => success.process,
//           'process',
//           SplashProcess.navigateToOnboarding,
//         ),
//       ],
//       verify: (_) {
//         verify(() => mockAppPreferencesService.getFirstTime()).called(1);
//         verifyNoMoreInteractions(mockAppPreferencesService);
//         verifyNoMoreInteractions(mockAuthStorageService);
//       },
//     );
//     blocTest(
//       "should emit SplashSuccess with navigateToAppSection when firstTime is false and accessToken is not null and _isLoggedIn is true",
//       build: () => sut,
//       setUp: () {
//         when(() => mockAppPreferencesService.getFirstTime()).thenReturn(false);
//         when(
//           () => mockAuthStorageService.getAccessToken(),
//         ).thenAnswer((_) async => 'access_token');
//         when(() => mockAppPreferencesService.getLoggedIn()).thenReturn(true);
//       },
//       act: (_) => sut.checkAppStatus(),
//       expect: () => [
//         isA<SplashSuccess>().having(
//           (success) => success.process,
//           'process',
//           SplashProcess.navigateToAppSection,
//         ),
//       ],
//       verify: (_) {
//         verify(() => mockAppPreferencesService.getFirstTime()).called(1);
//         verify(() => mockAuthStorageService.getAccessToken()).called(1);
//         verify(() => mockAppPreferencesService.getLoggedIn()).called(1);
//         verifyNoMoreInteractions(mockAppPreferencesService);
//         verifyNoMoreInteractions(mockAuthStorageService);
//       },
//     );
//     blocTest(
//       "should emit SplashSuccess with navigateToLogin when firstTime is false and accessToken is null or empty",
//       build: () => sut,
//       setUp: () {
//         when(() => mockAppPreferencesService.getFirstTime()).thenReturn(false);
//         when(
//           () => mockAuthStorageService.getAccessToken(),
//         ).thenAnswer((_) async => null);
//       },
//       act: (_) => sut.checkAppStatus(),
//       expect: () => [
//         isA<SplashSuccess>().having(
//           (success) => success.process,
//           'process',
//           SplashProcess.navigateToLogin,
//         ),
//       ],
//       verify: (_) {
//         verify(() => mockAppPreferencesService.getFirstTime()).called(1);
//         verify(() => mockAuthStorageService.getAccessToken()).called(1);
//         verifyNoMoreInteractions(mockAppPreferencesService);
//         verifyNoMoreInteractions(mockAuthStorageService);
//       },
//     );
//   });
// }
