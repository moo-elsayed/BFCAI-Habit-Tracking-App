import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import '../../../../core/entities/tracking/create_habit_tracking_input_entity.dart';

abstract class HomeRepo {
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
