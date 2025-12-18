import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/helpers/network_response.dart';

class EditHabitUseCase {
  EditHabitUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<String>> call(HabitEntity input) async =>
      _habitRepo.editHabit(input);
}
