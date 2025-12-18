import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/entities/tracking/create_habit_tracking_input_entity.dart';
import '../../../../../core/entities/tracking/edit_habit_tracking_input_entity.dart';
import '../../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../../core/helpers/network_response.dart';

abstract class HomeRemoteDataSource {
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits();

  Future<NetworkResponse<List<HabitTrackingEntity>>> getTrackedHabitsByDate(
    DateTime date,
  );

  Future<NetworkResponse<String>> createHabitTracking(
    CreateHabitTrackingInputEntity input,
  );

  Future<NetworkResponse<String>> editHabitTracking(
    EditHabitTrackingInputEntity input,
  );
}
