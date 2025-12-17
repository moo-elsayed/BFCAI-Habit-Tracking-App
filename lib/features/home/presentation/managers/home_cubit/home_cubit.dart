import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_all_habits_use_case.dart';
import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._allHabitsUseCase) : super(HomeInitial());
  final GetAllHabitsUseCase _allHabitsUseCase;

  List<HabitEntity> habits = [];

  Future<void> getAllHabits() async {
    emit(HomeLoading(.getAll));
    var result = await _allHabitsUseCase.call();
    switch (result) {
      case NetworkSuccess<List<HabitEntity>>():
        habits = result.data!;
        emit(HomeSuccess(.getAll, habits));
      case NetworkFailure<List<HabitEntity>>():
        emit(HomeFailure(getErrorMessage(result), .getAll));
    }
  }
}
