import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/get_habit_history_input_entity.dart';
import '../../../domain/entities/habit_history_entity.dart';

abstract class HabitRemoteDataSource {
  Future<NetworkResponse<String>> addHabit(HabitEntity input);

  Future<NetworkResponse<String>> editHabit(HabitEntity input);

  Future<NetworkResponse<String>> deleteHabit(int id);

  Future<NetworkResponse<List<HabitHistoryEntity>>> getHabitHistory(
    GetHabitHistoryInputEntity input,
  );
}
