import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/habit_entity.dart';

class AddHabitUseCase {
  AddHabitUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<String>> addHabit(HabitEntity input) async =>
      _habitRepo.addHabit(input);
}
