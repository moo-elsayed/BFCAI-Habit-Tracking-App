import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/network_response.dart';

abstract class HomeRemoteDataSource {
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits();
}
