import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/shared_data/models/habit_model.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source.dart';

import '../../../../../core/helpers/functions.dart';

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  HomeRemoteDataSourceImp(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<NetworkResponse<List<HabitEntity>>> getAllHabits() async {
    try {
      var response = await _databaseService.getAllData(ApiConstants.getHabits);
      var habits = response
          .map((json) => HabitModel.fromJson(json).toEntity())
          .toList();
      return NetworkSuccess(habits);
    } on DioException catch (e) {
      return handleError(e, "getAllHabits");
    } catch (e) {
      return handleError(e, "getAllHabits");
    }
  }
}
