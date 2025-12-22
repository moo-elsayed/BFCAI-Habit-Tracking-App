import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/entities/habit_schedule_entity.dart';
import '../../../../core/helpers/enums.dart';

class HabitFormHelper {
  final HabitEntity? _initialHabit;

  HabitFormHelper(this._initialHabit) {
    _init();
  }

  late final TextEditingController nameController;
  late final GlobalKey<FormState> formKey;

  // Notifiers
  late final ValueNotifier<HabitType> typeNotifier;
  late final ValueNotifier<Color> colorNotifier;
  late final ValueNotifier<IconData> iconNotifier;
  late final ValueNotifier<int> countNotifier;
  late final ValueNotifier<List<int>> daysNotifier;
  late final ValueNotifier<List<DateTime>> remindersNotifier;

  bool get isValid => formKey.currentState!.validate();

  void _init() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: _initialHabit?.name ?? '');
    typeNotifier = ValueNotifier(_initialHabit?.type ?? HabitType.task);
    colorNotifier = ValueNotifier(
      _initialHabit != null
          ? _hexToColor(_initialHabit.color)
          : Colors.deepPurple,
    );
    iconNotifier = ValueNotifier(
      IconData(
        int.tryParse(_initialHabit?.icon ?? '') ??
            Icons.sports_basketball.codePoint,
        fontFamily: 'MaterialIcons',
      ),
    );
    countNotifier = ValueNotifier(_initialHabit?.targetValue ?? 1);
    daysNotifier = ValueNotifier(
      _initialHabit != null
          ? _mapSchedulesToDaysList(_initialHabit.habitSchedules)
          : List.generate(7, (index) => 1),
    );
    remindersNotifier = ValueNotifier(
      _initialHabit != null
          ? _mapSchedulesToReminders(_initialHabit.habitSchedules)
          : [],
    );
  }

  void dispose() {
    nameController.dispose();
    typeNotifier.dispose();
    colorNotifier.dispose();
    iconNotifier.dispose();
    countNotifier.dispose();
    daysNotifier.dispose();
    remindersNotifier.dispose();
  }

  HabitEntity get entity {
    return HabitEntity(
      id: _initialHabit?.id,
      name: nameController.text.trim(),
      type: typeNotifier.value,
      targetValue: countNotifier.value,
      isActive: true,
      startDate: _initialHabit?.startDate ?? DateTime.now(),
      color:
          "0xFF${colorNotifier.value.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}",
      icon: iconNotifier.value.codePoint.toString(),
      habitSchedules: _generateSchedules(),
    );
  }

  Color _hexToColor(String code) {
    try {
      return Color(int.parse(code));
    } catch (e) {
      return Colors.deepPurple;
    }
  }

  List<HabitScheduleEntity> _generateSchedules() {
    List<HabitScheduleEntity> schedules = [];
    List<int> selectedDays = daysNotifier.value;
    List<DateTime> reminders = remindersNotifier.value;

    for (int i = 1; i <= selectedDays.length; i++) {
      if (selectedDays[i - 1] == 1) {
        if (reminders.isNotEmpty) {
          for (var time in reminders) {
            schedules.add(
              HabitScheduleEntity(
                dayOfWeek: i,
                notificationTime: DateFormat('HH:mm:ss').format(time),
              ),
            );
          }
        } else {
          schedules.add(
            HabitScheduleEntity(dayOfWeek: i, notificationTime: null),
          );
        }
      }
    }
    return schedules;
  }

  List<int> _mapSchedulesToDaysList(List<HabitScheduleEntity> schedules) {
    List<int> days = List.filled(7, 0);
    for (var schedule in schedules) {
      if (schedule.dayOfWeek >= 1 && schedule.dayOfWeek <= 7) {
        days[schedule.dayOfWeek - 1] = 1;
      }
    }
    return days;
  }

  List<DateTime> _mapSchedulesToReminders(List<HabitScheduleEntity> schedules) {
    final Set<String> uniqueTimes = {};
    final List<DateTime> reminders = [];

    for (var schedule in schedules) {
      if (schedule.notificationTime != null &&
          !uniqueTimes.contains(schedule.notificationTime)) {
        uniqueTimes.add(schedule.notificationTime!);
        try {
          final now = DateTime.now();
          final timeParts = schedule.notificationTime!.split(':');
          final time = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
            int.parse(timeParts[2].split('.')[0]),
          );
          reminders.add(time);
        } catch (e) {
          log(e.toString());
        }
      }
    }
    return reminders;
  }
}
