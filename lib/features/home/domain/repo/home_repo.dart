import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';

abstract class HomeRepo {
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits();
}
