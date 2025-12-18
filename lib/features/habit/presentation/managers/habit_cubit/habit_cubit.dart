import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/add_habit_use_case.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/delete_habit_use_case.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/edit_habit_use_case.dart';

import '../../../../../core/entities/habit_entity.dart';

part 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit(
    this._addHabitUseCase,
    this._deleteHabitUseCase,
    this._editHabitUseCase,
  ) : super(HabitInitial());
  final AddHabitUseCase _addHabitUseCase;
  final DeleteHabitUseCase _deleteHabitUseCase;
  final EditHabitUseCase _editHabitUseCase;

  Future<void> addHabit(HabitEntity input) async {
    emit(HabitLoading(.add));
    var result = await _addHabitUseCase.call(input);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HabitSuccess(.add));
      case NetworkFailure<String>():
        emit(HabitFailure(getErrorMessage(result).tr(), .add));
    }
  }

  Future<void> editHabit(HabitEntity input) async {
    emit(HabitLoading(.edit));
    var result = await _editHabitUseCase.call(input);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HabitSuccess(.edit));
      case NetworkFailure<String>():
        emit(HabitFailure(getErrorMessage(result).tr(), .edit));
    }
  }

  Future<void> deleteHabit(int id) async {
    emit(HabitLoading(.delete));
    var result = await _deleteHabitUseCase.call(id);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HabitSuccess(.delete));
      case NetworkFailure<String>():
        emit(HabitFailure(getErrorMessage(result).tr(), .delete));
    }
  }
}
