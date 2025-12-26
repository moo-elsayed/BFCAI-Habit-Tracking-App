import '../../../core/entities/habit_entity.dart';
import '../../../core/services/notification_service/local_notification_service.dart';
import '../../../core/services/notification_service/notification_service.dart';

class LocalNotificationServiceImp implements NotificationService {
  @override
  Future<void> init() async => await LocalNotificationService.init();

  @override
  Future<void> cancelAll() async => await LocalNotificationService.cancelAll();

  @override
  Future<void> scheduleHabit(HabitEntity habit) async =>
      await LocalNotificationService.scheduleHabit(habit);

  @override
  Future<void> cancelHabitNotifications(int habitId) async =>
      await LocalNotificationService.cancelHabitNotifications(habitId);
}
