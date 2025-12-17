import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  HomeRepoImp(this._homeRemoteDataSource);

  final HomeRemoteDataSource _homeRemoteDataSource;

  @override
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits() async =>
      await _homeRemoteDataSource.getAllHabits();
}
