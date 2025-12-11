import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/features/settings/domain/entities/user_info_entity.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._appPreferencesService) : super(SettingsInitial());
  final AppPreferencesService _appPreferencesService;

  late UserInfoEntity userInfoEntity;

  void getUserInfo() {
    userInfoEntity = UserInfoEntity(
      userName: userName,
      email: email
    );
  }

  String get userName => _appPreferencesService.getUsername();

  String get email => _appPreferencesService.getEmailAddress();
}
