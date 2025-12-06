import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(LoginInitial());

  final LoginUseCase _loginUseCase;

  Future<void> login(LoginInputEntity input) async {
    emit(LoginLoading());
    var networkResponse = await _loginUseCase.call(input);
    switch (networkResponse) {
      case NetworkSuccess<LoginResponseEntity>():
        emit(LoginSuccess());
      case NetworkFailure<LoginResponseEntity>():
        emit(LoginFailure(getErrorMessage(networkResponse).tr()));
    }
  }
}
