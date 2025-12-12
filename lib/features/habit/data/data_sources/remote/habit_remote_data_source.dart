import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/habit_entity.dart';

abstract class HabitRemoteDataSource {
  Future<NetworkResponse<String>> addHabit(HabitEntity input);
}
