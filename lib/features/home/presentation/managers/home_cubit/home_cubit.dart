import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/tracking_record_entity.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/create_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/edit_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_all_habits_use_case.dart';
import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/use_cases/get_tracked_habits_by_date_use_case.dart';
import 'package:collection/collection.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._allHabitsUseCase,
    this._getTrackedHabitsByDateUseCase,
    this._createHabitTrackingUseCase,
    this._editHabitTrackingUseCase,
  ) : super(HomeInitial());
  final GetAllHabitsUseCase _allHabitsUseCase;
  final GetTrackedHabitsByDateUseCase _getTrackedHabitsByDateUseCase;
  final CreateHabitTrackingUseCase _createHabitTrackingUseCase;
  final EditHabitTrackingUseCase _editHabitTrackingUseCase;

  List<HabitEntity> _allHabits = [];
  List<HabitTrackingEntity> _trackedHabits = [];
  List<HabitTrackingEntity> uiHabitsList = [];

  Future<void> getHomeHabits({
    required DateTime date,
    bool getAll = false,
  }) async {
    emit(HomeLoading(.getHomeHabits));
    if (_allHabits.isEmpty || getAll) {
      var habitsResult = await _allHabitsUseCase.call();
      switch (habitsResult) {
        case NetworkSuccess<List<HabitEntity>>():
          _allHabits = habitsResult.data!;
          log(_allHabits.length.toString());
        case NetworkFailure<List<HabitEntity>>():
          emit(HomeFailure(getErrorMessage(habitsResult), .getHomeHabits));
          return;
      }
    }
    var trackingResult = await _getTrackedHabitsByDateUseCase.call(date);
    switch (trackingResult) {
      case NetworkSuccess<List<HabitTrackingEntity>>():
        _trackedHabits = trackingResult.data!;
        _mergeAndFilterHabits(date);
        emit(
          HomeSuccess(
            process: HomeProcess.getHomeHabits,
            uiHabits: uiHabitsList,
          ),
        );
      case NetworkFailure<List<HabitTrackingEntity>>():
        emit(
          HomeFailure(
            getErrorMessage(trackingResult),
            HomeProcess.getHomeHabits,
          ),
        );
    }
  }

  Future<void> createHabitTracking(CreateHabitTrackingInputEntity input) async {
    emit(HomeLoading(.create));
    var result = await _createHabitTrackingUseCase.call(input);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HomeSuccess(process: .create));
      case NetworkFailure<String>():
        emit(HomeFailure(getErrorMessage(result), .create));
    }
  }

  Future<void> editHabitTracking(EditHabitTrackingInputEntity input) async {
    emit(HomeLoading(.edit));
    var result = await _editHabitTrackingUseCase.call(input);
    switch (result) {
      case NetworkSuccess<String>():
        emit(HomeSuccess(process: .edit));
      case NetworkFailure<String>():
        emit(HomeFailure(getErrorMessage(result), .edit));
    }
  }

  HabitEntity getEquivalentHabit(HabitTrackingEntity habit) =>
      _allHabits.firstWhere((h) => h.id == habit.habitId);

  // --------------------------------------

  void _mergeAndFilterHabits(DateTime date) {
    uiHabitsList.clear();
    String dayName = DateFormat('EEEE').format(date);
    for (var habit in _allHabits) {
      bool isScheduledForToday = habit.habitSchedules.any(
        (s) => parseDayStringToInt(dayName) == s.dayOfWeek,
      );

      if (isScheduledForToday) {
        var trackedHabit = _trackedHabits.firstWhereOrNull(
          (t) => t.habitId == habit.id,
        );
        if (trackedHabit != null) {
          uiHabitsList.add(trackedHabit);
        } else {
          uiHabitsList.add(
            HabitTrackingEntity(
              habitId: habit.id!,
              name: habit.name,
              type: habit.type,
              targetValue: habit.targetValue,
              icon: habit.icon,
              color: habit.color,
              isActive: habit.isActive,
              trackingRecordEntity: TrackingRecordEntity(
                currentValue: 0,
                progressPercentage: 0,
                status: 'Pending',
                updatedAt: date.toIso8601String(),
              ),
            ),
          );
        }
      }
    }
  }
}

// Future<void> getAllHabits() async {
//   emit(HomeLoading(.getAll));
//   var result = await _allHabitsUseCase.call();
//   switch (result) {
//     case NetworkSuccess<List<HabitEntity>>():
//       _allHabits = result.data!;
//       emit(HomeSuccess(process: .getAll, allHabits: _allHabits));
//     case NetworkFailure<List<HabitEntity>>():
//       emit(HomeFailure(getErrorMessage(result), .getAll));
//   }
// }
//
// Future<void> getTrackedHabitsByDate(DateTime date) async {
//   emit(HomeLoading(.getTrackedHabitsByDate));
//   var result = await _getTrackedHabitsByDateUseCase.call(date);
//   switch (result) {
//     case NetworkSuccess<List<HabitTrackingEntity>>():
//       _trackedHabits = result.data!;
//       _fillUiHabitsList();
//       emit(
//         HomeSuccess(
//           process: .getTrackedHabitsByDate,
//           trackedHabits: _trackedHabits,
//         ),
//       );
//     case NetworkFailure<List<HabitTrackingEntity>>():
//       emit(HomeFailure(getErrorMessage(result), .getTrackedHabitsByDate));
//   }
// }
