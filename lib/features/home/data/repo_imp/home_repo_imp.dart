import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  HomeRepoImp(this._homeRemoteDataSource);

  final HomeRemoteDataSource _homeRemoteDataSource;

  @override
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits() async =>
      await _homeRemoteDataSource.getAllHabits();

  @override
  Future<NetworkResponse<List<HabitTrackingEntity>>> getTrackedHabitsByDate(
    DateTime date,
  ) async => await _homeRemoteDataSource.getTrackedHabitsByDate(date);

  @override
  Future<NetworkResponse<String>> createHabitTracking(
    CreateHabitTrackingInputEntity input,
  ) async => await _homeRemoteDataSource.createHabitTracking(input);

  @override
  Future<NetworkResponse<String>> editHabitTracking(
    EditHabitTrackingInputEntity input,
  ) async => await _homeRemoteDataSource.editHabitTracking(input);
}
