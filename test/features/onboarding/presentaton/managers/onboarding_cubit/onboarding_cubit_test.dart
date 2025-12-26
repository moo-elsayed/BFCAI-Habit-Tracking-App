import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/features/onboarding/presentation/managers/onboarding_cubit/onboarding_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  late OnboardingCubit sut;
  late MockAppPreferencesService mockAppPreferencesService;

  setUp(() {
    mockAppPreferencesService = .new();
    sut = .new(mockAppPreferencesService);
  });

  tearDown(() async {
    await sut.close();
  });

  group('onboarding cubit', () {
    test('initial state should be OnboardingInitial', () {
      expect(sut.state, isA<OnboardingInitial>());
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'emits OnboardingNavigateToHome after setting first time',
      build: () => sut,
      setUp: () {
        when(
          () => mockAppPreferencesService.setFirstTime(any()),
        ).thenAnswer((_) async => true);
      },
      act: (cubit) => cubit.setFirstTime(false),
      expect: () => [isA<OnboardingNavigateToHome>()],
      verify: (_) {
        verify(() => mockAppPreferencesService.setFirstTime(false)).called(1);
        verifyNoMoreInteractions(mockAppPreferencesService);
      },
    );
  });
}
