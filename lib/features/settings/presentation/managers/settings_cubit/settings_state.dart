part of 'settings_cubit.dart';

enum SettingsProcess { getUserInfo, none }

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsSuccess extends SettingsState {
  SettingsSuccess({required this.userInfoEntity, required this.process});

  final UserInfoEntity userInfoEntity;
  final SettingsProcess process;
}
