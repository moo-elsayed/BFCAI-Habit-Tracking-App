import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/api_constants.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/features/habit/data/data_sources/remote/habit_remote_data_source.dart';
import 'package:habit_tracking_app/features/habit/data/models/habit_model.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_entity.dart';
import '../../../../../core/helpers/functions.dart';

class HabitRemoteDataSourceImp implements HabitRemoteDataSource {
  HabitRemoteDataSourceImp(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<NetworkResponse<String>> addHabit(HabitEntity input) async {
    try {
      var apiResponse = await _databaseService.addData(
        path: ApiConstants.createHabit,
        data: HabitModel.fromEntity(input).toJson(),
      );
      return NetworkSuccess(apiResponse.data);
    } on DioException catch (e) {
      return handleError(e, "addHabit");
    } catch (e) {
      return handleError(e, "addHabit");
    }
  }
}
