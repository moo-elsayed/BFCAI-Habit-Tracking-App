import '../../entities/habit_entity.dart';

abstract class NotificationService {
  Future<void> init();

  Future<void> cancelAll();

  Future<void> scheduleHabit(HabitEntity habit);

  Future<void> cancelHabitNotifications(int habitId);
}
