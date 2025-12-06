import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._logoutUseCase) : super(LogoutInitial());
  final LogoutUseCase _logoutUseCase;

  Future<void> logout() async {
    emit(LogoutLoading());
    var networkResponse = await _logoutUseCase.call();
    switch (networkResponse) {
      case NetworkSuccess<String>():
        emit(LogoutSuccess());
      case NetworkFailure<String>():
        emit(LogoutFailure(getErrorMessage(networkResponse).tr()));
    }
  }
}
