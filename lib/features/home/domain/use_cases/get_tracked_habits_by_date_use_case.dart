import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/helpers/network_response.dart';

class GetTrackedHabitsByDateUseCase {
  GetTrackedHabitsByDateUseCase(this._homeRepo);

  final HomeRepo _homeRepo;

  Future<NetworkResponse<List<HabitTrackingEntity>>> call(
    DateTime date,
  ) async => await _homeRepo.getTrackedHabitsByDate(date);
}
