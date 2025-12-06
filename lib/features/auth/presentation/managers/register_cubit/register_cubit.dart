import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/register_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(RegisterInitial());
  final RegisterUseCase _registerUseCase;

  Future<void> register(RegisterInputEntity input) async {
    emit(RegisterLoading());
    var networkResponse = await _registerUseCase.call(input);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        emit(RegisterSuccess());
      case NetworkFailure<String>():
        emit(RegisterFailure(getErrorMessage(networkResponse).tr()));
    }
  }
}
