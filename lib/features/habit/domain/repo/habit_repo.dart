import 'package:habit_tracking_app/core/helpers/network_response.dart';
import '../../../../core/entities/habit_entity.dart';

abstract class HabitRepo {
  Future<NetworkResponse<String>> addHabit(HabitEntity input);
  Future<NetworkResponse<String>> editHabit(HabitEntity input);
  Future<NetworkResponse<String>> deleteHabit(int id);
}
