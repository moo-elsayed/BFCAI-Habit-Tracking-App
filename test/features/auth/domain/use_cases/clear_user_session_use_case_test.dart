import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
import 'package:habit_tracking_app/core/services/notification_service/notification_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockAuthStorageService extends Mock implements AuthStorageService {}

class MockNotificationService extends Mock implements NotificationService {}
