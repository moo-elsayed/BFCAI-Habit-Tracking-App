import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';

abstract class HabitRemoteDataSource {
  Future<NetworkResponse<String>> addHabit(HabitEntity input);
  Future<NetworkResponse<String>> editHabit(HabitEntity input);
  Future<NetworkResponse<String>> deleteHabit(int id);
}
