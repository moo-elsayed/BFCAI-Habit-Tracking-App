import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/get_habit_history_input_entity.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_history_entity.dart';
import '../../../../core/entities/habit_entity.dart';

abstract class HabitRepo {
  Future<NetworkResponse<String>> addHabit(HabitEntity input);

  Future<NetworkResponse<String>> editHabit(HabitEntity input);

  Future<NetworkResponse<String>> deleteHabit(int id);

  Future<NetworkResponse<List<HabitHistoryEntity>>> getHabitHistory(
    GetHabitHistoryInputEntity input,
  );
}
