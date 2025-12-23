import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/habit/data/data_sources/remote/habit_remote_data_source.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/get_habit_history_input_entity.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_history_entity.dart';
import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/entities/habit_entity.dart';

class HabitRepoImp implements HabitRepo {
  HabitRepoImp(this._habitRemoteDataSource);

  final HabitRemoteDataSource _habitRemoteDataSource;

  @override
  Future<NetworkResponse<String>> addHabit(HabitEntity input) async =>
      _habitRemoteDataSource.addHabit(input);

  @override
  Future<NetworkResponse<String>> deleteHabit(int id) async =>
      _habitRemoteDataSource.deleteHabit(id);

  @override
  Future<NetworkResponse<String>> editHabit(input) async =>
      _habitRemoteDataSource.editHabit(input);

  @override
  Future<NetworkResponse<List<HabitHistoryEntity>>> getHabitHistory(
    GetHabitHistoryInputEntity input,
  ) async => _habitRemoteDataSource.getHabitHistory(input);
}
