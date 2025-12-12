import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_entity.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/add_habit_use_case.dart';

part 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit(this._addHabitUseCase) : super(HabitInitial());
  final AddHabitUseCase _addHabitUseCase;

  Future<void> addHabit(HabitEntity input) async {
    emit(HabitLoading());
    var result = await _addHabitUseCase.addHabit(input);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HabitSuccess());
      case NetworkFailure<String>():
        emit(HabitFailure(getErrorMessage(result).tr()));
    }
  }
}
