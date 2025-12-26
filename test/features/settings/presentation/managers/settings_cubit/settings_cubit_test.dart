import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/features/settings/domain/entities/user_info_entity.dart';
import 'package:habit_tracking_app/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  late SettingsCubit sut;
  late MockAppPreferencesService mockAppPreferencesService;

  setUp(() {
    mockAppPreferencesService = .new();
    sut = .new(mockAppPreferencesService);
  });

  tearDown(() async {
    await sut.close();
  });

  group('settings cubit', () {
    test('initial state should be SettingsInitial', () {
      expect(sut.state, isA<SettingsInitial>());
    });

    blocTest<SettingsCubit, SettingsState>(
      'emits SettingsSuccess with user info when getUserInfo is called',
      build: () => sut,
      setUp: () {
        when(
          () => mockAppPreferencesService.getUsername(),
        ).thenReturn('John Doe');
        when(
          () => mockAppPreferencesService.getEmailAddress(),
        ).thenReturn('john@mail.com');
      },
      act: (cubit) => cubit.getUserInfo(),
      expect: () => [
        isA<SettingsSuccess>()
            .having(
              (state) => state.process,
              'process',
              SettingsProcess.getUserInfo,
            )
            .having(
              (state) => state.userInfoEntity,
              'userInfoEntity',
              isA<UserInfoEntity>()
                  .having((u) => u.userName, 'userName', 'John Doe')
                  .having((u) => u.email, 'email', 'john@mail.com'),
            ),
      ],
      verify: (_) {
        verify(() => mockAppPreferencesService.getUsername()).called(1);
        verify(() => mockAppPreferencesService.getEmailAddress()).called(1);
        verifyNoMoreInteractions(mockAppPreferencesService);
      },
    );
  });
}
