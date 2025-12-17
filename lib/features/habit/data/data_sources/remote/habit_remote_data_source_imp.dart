import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/features/habit/data/data_sources/remote/habit_remote_data_source.dart';
import 'package:habit_tracking_app/shared_data/models/habit_model.dart';
import '../../../../../core/entities/habit_entity.dart';
import '../../../../../core/helpers/functions.dart';

class HabitRemoteDataSourceImp implements HabitRemoteDataSource {
  HabitRemoteDataSourceImp(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<NetworkResponse<String>> addHabit(HabitEntity input) async {
    try {
      var message = await _databaseService.addData(
        path: ApiConstants.createHabit,
        data: HabitModel.fromEntity(input).toJson(),
      );
      return NetworkSuccess(message);
    } on DioException catch (e) {
      return handleError(e, "addHabit");
    } catch (e) {
      return handleError(e, "addHabit");
    }
  }

  @override
  Future<NetworkResponse<String>> deleteHabit(int id) async {
    try {
      var message = await _databaseService.deleteData(
        path: ApiConstants.deleteHabit,
        id: id,
      );
      return NetworkSuccess(message);
    } on DioException catch (e) {
      return handleError(e, "deleteHabit");
    } catch (e) {
      return handleError(e, "deleteHabit");
    }
  }

  @override
  Future<NetworkResponse<String>> editHabit(HabitEntity input) async {
    try {
      var message = await _databaseService.updateData(
        path: ApiConstants.editHabit,
        data: HabitModel.fromEntity(input).toJson(),
      );
      return NetworkSuccess(message);
    } on DioException catch (e) {
      return handleError(e, "editHabit");
    } catch (e) {
      return handleError(e, "editHabit");
    }
  }
}
