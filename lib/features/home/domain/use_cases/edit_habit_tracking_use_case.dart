import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import '../../../../core/entities/tracking/edit_habit_tracking_input_entity.dart';
import '../../../../core/helpers/network_response.dart';

class EditHabitTrackingUseCase {
  EditHabitTrackingUseCase(this._homeRepo);

  final HomeRepo _homeRepo;

  Future<NetworkResponse<String>> call(
    EditHabitTrackingInputEntity input,
  ) async => await _homeRepo.editHabitTracking(input);
}
