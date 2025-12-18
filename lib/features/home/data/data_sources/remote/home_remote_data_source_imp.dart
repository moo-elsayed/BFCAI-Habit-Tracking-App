import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/core/services/database_service/query_parameters.dart';
import 'package:habit_tracking_app/shared_data/models/habit_model.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source.dart';
import 'package:habit_tracking_app/shared_data/models/tracking/create_habit_tracking_input_model.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../shared_data/models/tracking/edit_habit_tracking_input_model.dart';
import '../../../../../shared_data/models/tracking/habit_tracking_model.dart';

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

  @override
  Future<NetworkResponse<String>> createHabitTracking(
    CreateHabitTrackingInputEntity input,
  ) async {
    try {
      var data = CreateHabitTrackingInputModel.fromEntity(input).toJson();
      var response = await _databaseService.addData(
        path: ApiConstants.createHabitTracking,
        data: data,
      );
      return NetworkSuccess(response);
    } on DioException catch (e) {
      return handleError(e, "createHabitTracking");
    } catch (e) {
      return handleError(e, "createHabitTracking");
    }
  }

  @override
  Future<NetworkResponse<String>> editHabitTracking(
    EditHabitTrackingInputEntity input,
  ) async {
    try {
      var params = EditHabitTrackingInputModel.fromEntity(input).toJson();
      var response = await _databaseService.updateData(
        path: ApiConstants.editHabitTracking,
        params: params,
      );
      return NetworkSuccess(response);
    } on DioException catch (e) {
      return handleError(e, "editHabitTracking");
    } catch (e) {
      return handleError(e, "editHabitTracking");
    }
  }

  @override
  Future<NetworkResponse<List<HabitTrackingEntity>>> getTrackedHabitsByDate(
    DateTime date,
  ) async {
    try {
      var response = await _databaseService.queryData(
        path: ApiConstants.getTrackedHabits,
        query: QueryParameters(date: date),
      );
      var habits = response
          .map((json) => HabitTrackingModel.fromJson(json).toEntity())
          .toList();
      return NetworkSuccess(habits);
    } on DioException catch (e) {
      return handleError(e, "getTrackedHabitsByDate");
    } catch (e) {
      return handleError(e, "getTrackedHabitsByDate");
    }
  }
}
