import 'habit_schedule_entity.dart';

enum HabitType {
  task(1),
  count(2);

  final int value;

  const HabitType(this.value);
}

class HabitEntity {
  const HabitEntity({
    this.id,
    this.name = '',
    this.type = .task,
    this.targetValue = 1,
    this.icon = '',
    this.color = '',
    required this.startDate,
    this.isActive = true,
    this.habitSchedules = const <HabitScheduleEntity>[],
  });

  final int? id;
  final String name;
  final HabitType type;
  final int targetValue;
  final String icon;
  final String color;
  final DateTime startDate;
  final bool isActive;
  final List<HabitScheduleEntity> habitSchedules;
}
