import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/shared_data/services/local_storage_service/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesManager sut;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sut = SharedPreferencesManager();
    sut.init();
  });

  group('SharedPreferencesManager Tests', () {
    group('setFirstTime', () {
      test('should return true for getFirstTime by default', () {
        // Act
        final result = sut.getFirstTime();
        // Assert
        expect(result, true);
      });
      test('should set isFirstTime correctly', () async {
        // Arrange
        const isFirstTime = true;
        // Act
        await sut.setFirstTime(isFirstTime);
        // Assert
        expect(sut.getFirstTime(), isFirstTime);
      });
    });
    group('setLoggedIn', () {
      test('should return false for getLoggedIn by default', () {
        // Act
        final result = sut.getLoggedIn();
        // Assert
        expect(result, false);
      });
      test('should set isLoggedIn correctly', () async {
        // Arrange
        const isLoggedIn = true;
        // Act
        await sut.setLoggedIn(isLoggedIn);
        // Assert
        expect(sut.getLoggedIn(), isLoggedIn);
      });
    });
    group('setUsername', () {
      test('should return empty string for getUsername by default', () {
        // Act
        final result = sut.getUsername();
        // Assert
        expect(result, '');
      });
      test('should set username correctly', () async {
        // Arrange
        const username = 'John Doe';
        // Act
        await sut.setUsername(username);
        // Assert
        expect(sut.getUsername(), username);
      });
    });
    group('deleteUseName', () {
      test('should delete username correctly', () async {
        // Arrange
        const username = 'John Doe';
        await sut.setUsername(username);
        // Act
        await sut.deleteUseName();
        // Assert
        expect(sut.getUsername(), '');
      });
    });
    group('set email address', () {
      test('should return empty string for getEmailAddress by default', () {
        // Act
        final result = sut.getEmailAddress();
        // Assert
        expect(result, '');
      });
      test('should set email address correctly', () async {
        // Arrange
        const emailAddress = 'John Doe';
        // Act
        await sut.setEmailAddress(emailAddress);
        // Assert
        expect(sut.getEmailAddress(), emailAddress);
      });
    });
    group('delete email address', () {
      test('should delete email address correctly', () async {
        // Arrange
        const emailAddress = 'John Doe';
        await sut.setEmailAddress(emailAddress);
        // Act
        await sut.deleteEmailAddress();
        // Assert
        expect(sut.getEmailAddress(), '');
      });
    });
    group('set theme mode', () {
      test('should return value when getThemeMode is called', () async {
        // Act
        await sut.setThemeMode('dark');
        // Assert
        expect(sut.getThemeMode(), 'dark');
      });
    });
    group('set habits scheduled', () {
      test('should return false for getHabitsScheduled by default', () {
        // Act
        final result = sut.getHabitsScheduled();
        // Assert
        expect(result, false);
      });
      test('should set habitsScheduled correctly', () async {
        // Arrange
        const habitsScheduled = true;
        // Act
        await sut.setHabitsScheduled(habitsScheduled);
        // Assert
        expect(sut.getHabitsScheduled(), habitsScheduled);
      });
    });
    group('delete habit scheduled', () {
      test('should delete habitsScheduled correctly', () async {
        // Arrange
        const habitsScheduled = true;
        await sut.setHabitsScheduled(habitsScheduled);
        // Act
        await sut.deleteHabitsScheduled();
        // Assert
        expect(sut.getHabitsScheduled(), false);
      });
    });
  });
}
