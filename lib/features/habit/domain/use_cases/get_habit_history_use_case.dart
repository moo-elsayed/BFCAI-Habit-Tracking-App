import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/get_habit_history_input_entity.dart';
import '../entities/habit_history_entity.dart';

class GetHabitHistoryUseCase {
  GetHabitHistoryUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<List<HabitHistoryEntity>>> call(
    GetHabitHistoryInputEntity input,
  ) async => await _habitRepo.getHabitHistory(input);
}
