import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/create_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/edit_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_all_habits_use_case.dart';
import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../../../core/services/local_notification_service/local_notification_service.dart';
import '../../../domain/use_cases/get_habits_by_date_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._allHabitsUseCase,
    this._getTrackedHabitsByDateUseCase,
    this._createHabitTrackingUseCase,
    this._editHabitTrackingUseCase,
    this._appPreferencesService,
  ) : super(HomeInitial());
  final GetAllHabitsUseCase _allHabitsUseCase;
  final GetHabitsByDateUseCase _getTrackedHabitsByDateUseCase;
  final CreateHabitTrackingUseCase _createHabitTrackingUseCase;
  final EditHabitTrackingUseCase _editHabitTrackingUseCase;
  final AppPreferencesService _appPreferencesService;

  List<HabitEntity> _allHabits = [];
  List<HabitTrackingEntity> _habitsByDate = [];
  List<HabitTrackingEntity> uiHabitsList = [];

  Future<void> getAllHabits() async {
    var result = await _allHabitsUseCase.call();
    switch (result) {
      case NetworkSuccess<List<HabitEntity>>():
        await _checkAndScheduleNotifications(result.data!);
        _allHabits = result.data!;
        log(_allHabits.length.toString());
      case NetworkFailure<List<HabitEntity>>():
        log(getErrorMessage(result));
    }
  }

  Future<void> getHabitsByDate(DateTime date) async {
    emit(HomeLoading(.getHabitsByDate));
    var result = await _getTrackedHabitsByDateUseCase.call(date);
    switch (result) {
      case NetworkSuccess<List<HabitTrackingEntity>>():
        _habitsByDate = result.data!;
        emit(HomeSuccess(process: .getHabitsByDate, habits: _habitsByDate));
      case NetworkFailure<List<HabitTrackingEntity>>():
        emit(HomeFailure(getErrorMessage(result), .getHabitsByDate));
    }
  }

  Future<void> createHabitTracking(CreateHabitTrackingInputEntity input) async {
    emit(HomeLoading(.create));
    var result = await _createHabitTrackingUseCase.call(input);
    switch (result) {
      case NetworkSuccess<int>():
        final newTrackingId = result.data!;
        var index = _habitsByDate.indexWhere((h) => h.habitId == input.habitId);
        if (index != -1) {
          final currentItem = _habitsByDate[index];
          _habitsByDate[index] = currentItem.copyWith(
            trackingRecordEntity: currentItem.trackingRecordEntity.copyWith(
              trackingId: newTrackingId,
              currentValue: input.currentValue,
              progressPercentage:
                  (input.currentValue / currentItem.targetValue) * 100,
              status: input.currentValue >= currentItem.targetValue
                  ? "Completed"
                  : "Pending",
            ),
          );
          emit(HomeSuccess(process: .create, habits: List.from(_habitsByDate)));
        }
      case NetworkFailure<int>():
        emit(HomeFailure(getErrorMessage(result), .create));
    }
  }

  Future<void> editHabitTracking(EditHabitTrackingInputEntity input) async {
    var index = _habitsByDate.indexWhere(
      (habit) => habit.trackingRecordEntity.trackingId == input.trackingId,
    );

    if (index == -1) return;
    final currentItem = _habitsByDate[index];
    final int oldQuantity = currentItem.trackingRecordEntity.currentValue;
    final int newQuantity = input.currentValue;

    _habitsByDate[index] = _habitsByDate[index].copyWith(
      trackingRecordEntity: _habitsByDate[index].trackingRecordEntity.copyWith(
        currentValue: newQuantity,
        progressPercentage: newQuantity / currentItem.targetValue * 100,
      ),
    );
    emit(HomeSuccess(process: .edit, habits: List.from(_habitsByDate)));

    var result = await _editHabitTrackingUseCase.call(input);
    switch (result) {
      case NetworkSuccess<String>():
        return;
      case NetworkFailure<String>():
        _habitsByDate[index] = _habitsByDate[index].copyWith(
          trackingRecordEntity: _habitsByDate[index].trackingRecordEntity
              .copyWith(
                currentValue: oldQuantity,
                progressPercentage: oldQuantity / currentItem.targetValue * 100,
              ),
        );
        emit(HomeFailure(getErrorMessage(result), .edit));
    }
  }

  HabitEntity getEquivalentHabit(HabitTrackingEntity habit) =>
      _allHabits.firstWhere((h) => h.id == habit.habitId);

  int getHabitsCountForDay(int weekday) {
    return _allHabits.where((habit) {
      return habit.habitSchedules.any(
        (schedule) => schedule.dayOfWeek == parseDateTimeToDayInt(weekday),
      );
    }).length;
  }

  Future<void> _checkAndScheduleNotifications(List<HabitEntity> habits) async {
    final bool isScheduled = _appPreferencesService.getHabitsScheduled();
    if (!isScheduled) {
      log("Detected fresh state. Scheduling all habits...");
      await LocalNotificationService.cancelAll();
      for (var habit in habits) {
        if (habit.isActive) {
          await LocalNotificationService.scheduleHabit(habit);
        }
      }
      _appPreferencesService.setHabitsScheduled(true);
    }
  }
}
