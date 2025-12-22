import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import '../../../../core/entities/tracking/create_habit_tracking_input_entity.dart';
import '../../../../core/helpers/network_response.dart';

class CreateHabitTrackingUseCase {
  CreateHabitTrackingUseCase(this._homeRepo);

  final HomeRepo _homeRepo;

  Future<NetworkResponse<int>> call(
    CreateHabitTrackingInputEntity input,
  ) async => await _homeRepo.createHabitTracking(input);
}
