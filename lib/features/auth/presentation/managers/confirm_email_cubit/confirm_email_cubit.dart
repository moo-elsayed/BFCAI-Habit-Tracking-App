import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/confirm_email_use_case.dart';
import '../../../domain/entities/input/confirm_email_input_entity.dart';

part 'confirm_email_state.dart';

class ConfirmEmailCubit extends Cubit<ConfirmEmailState> {
  ConfirmEmailCubit(this._confirmEmailUseCase) : super(ConfirmEmailInitial());
  final ConfirmEmailUseCase _confirmEmailUseCase;

  Future<void> confirmEmail(ConfirmEmailInputEntity input) async {
    emit(ConfirmEmailLoading());
    var networkResponse = await _confirmEmailUseCase.call(input);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        emit(ConfirmEmailSuccess());
      case NetworkFailure<String>():
        emit(ConfirmEmailFailure(getErrorMessage(networkResponse).tr()));
    }
  }
}
