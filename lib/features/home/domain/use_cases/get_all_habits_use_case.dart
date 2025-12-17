import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/helpers/network_response.dart';

class GetAllHabitsUseCase {
  GetAllHabitsUseCase(this._homeRepo);

  final HomeRepo _homeRepo;

  Future<NetworkResponse<List<HabitEntity>>> call() async =>
      await _homeRepo.getAllHabits();
}
