import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/habit/data/data_sources/remote/habit_remote_data_source.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_entity.dart';
import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';

class HabitRepoImp implements HabitRepo {
  HabitRepoImp(this._habitRemoteDataSource);

  final HabitRemoteDataSource _habitRemoteDataSource;

  @override
  Future<NetworkResponse<String>> addHabit(HabitEntity input) async =>
      _habitRemoteDataSource.addHabit(input);
}
