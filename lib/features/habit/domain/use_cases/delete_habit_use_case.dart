import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/helpers/network_response.dart';

class DeleteHabitUseCase {
  DeleteHabitUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<String>> call(int id) async =>
      _habitRepo.deleteHabit(id);
}
