import 'dart:async';
import 'dart:developer';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  static const String _channelId = 'habit_channel_v2';
  static const String _channelName = 'Habit Reminders';
  static const String _channelDesc = 'Notifications for your daily habits';

  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  // ================= INIT =================
  static Future<void> init() async {
    tz.initializeTimeZones();
    final TimezoneInfo timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await requestPermissions();
  }

  // ================= PERMISSIONS =================
  static Future<bool> requestPermissions() async {
    bool permissionGranted = true;
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      permissionGranted = status.isGranted;
    }

    // Exact Alarm permission (Android 12+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    return permissionGranted;
  }

  // ================= CORE: SCHEDULE HABIT =================
  static Future<void> scheduleHabit(HabitEntity habit) async {
    if (!habit.isActive || habit.habitSchedules.isEmpty || habit.id == null) {
      return;
    }

    // 1. نمسح أي جدولة قديمة للعادة دي عشان نضمن مفيش تضارب
    await cancelHabitNotifications(habit.id!);

    // 2. نلف على كل ميعاد ونعمله Schedule
    for (var schedule in habit.habitSchedules) {
      if (schedule.notificationTime == null) continue;

      try {
        // تحويل اليوم والوقت لـ TZDateTime القادم
        final tz.TZDateTime nextDate = _nextInstanceOfDayAndTime(
          schedule.dayOfWeek, // e.g., "Friday" or int depending on your API
          schedule.notificationTime!, // "00:00:00"
        );

        // توليد ID فريد: (HabitID * 100) + DayIndex (1-7)
        // مثال: habitId 9, Friday(5) -> ID = 905
        final int notificationId = _generateNotificationId(
          habit.id!,
          schedule.dayOfWeek,
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          'Time for ${habit.name}!',
          habit.type.name,
          nextDate,
          _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: '${habit.id}',
        );

        log(
          '✅ Scheduled: ${habit.name} on ${schedule.dayOfWeek} at $nextDate (ID: $notificationId)',
        );
      } catch (e) {
        log('❌ Failed to schedule habit ${habit.name}: $e');
      }
    }
  }

  // ================= CANCEL HABIT =================
  static Future<void> cancelHabitNotifications(int habitId) async {
    for (int i = 1; i <= 7; i++) {
      final int notificationId = (habitId * 100) + i;
      await flutterLocalNotificationsPlugin.cancel(notificationId);
    }
    log('🗑️ Cancelled notifications for habit ID: $habitId');
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // ================= HELPER METHODS =================

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static tz.TZDateTime _nextInstanceOfDayAndTime(
    dynamic dayOfWeek,
    String timeString,
  ) {
    final List<String> timeParts = timeString.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    int targetWeekday;
    if (dayOfWeek is int) {
      targetWeekday = dayOfWeek;
    } else {
      targetWeekday = parseDayStringToIntForNotifications(dayOfWeek.toString());
    }

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // نبدأ من "النهاردة" بنفس توقيت العادة
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // لو اليوم مش هو المطلوب، نزود يوم لحد ما نوصل لليوم المطلوب
    while (scheduledDate.weekday != targetWeekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // لو الميعاد ده فات النهاردة، يبقى نخليه الأسبوع الجاي
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  static int _generateNotificationId(int habitId, dynamic dayOfWeek) {
    int dayIndex = (dayOfWeek is int)
        ? dayOfWeek
        : parseDayStringToIntForNotifications(dayOfWeek.toString());
    return (habitId * 100) + dayIndex;
  }
}
