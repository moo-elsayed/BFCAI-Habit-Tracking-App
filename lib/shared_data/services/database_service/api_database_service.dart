import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/core/services/database_service/query_parameters.dart';
import 'package:habit_tracking_app/shared_data/models/api_response/api_response.dart';
import '../../../core/helpers/functions.dart';

class ApiDatabaseService implements DatabaseService {
  ApiDatabaseService(this._dio);

  final Dio _dio;

  @override
  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post(path, data: data);
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    return returnResponse<String>(apiResponse, response);
  }

  @override
  Future<String> deleteData({required String path, required int id}) async {
    final response = await _dio.delete("$path/$id");
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    return returnResponse<String>(apiResponse, response);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllData(String path) async {
    final response = await _dio.get(path);
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => e as Map<String, dynamic>).toList(),
    );
    return returnResponse<List<Map<String, dynamic>>>(apiResponse, response);
  }

  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  }) async {
    final response = await _dio.get("$path/$id");
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
    return returnResponse<Map<String, dynamic>>(apiResponse, response);
  }

  @override
  Future<String> updateData({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
  }) async {
    final response = await _dio.put(path, data: data, queryParameters: params);
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    return returnResponse<String>(apiResponse, response);
  }

  @override
  Future<List<Map<String, dynamic>>> queryData({
    required String path,
    required QueryParameters query,
  }) async {
    final response = await _dio.get(path, queryParameters: query.toJson());
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => e as Map<String, dynamic>).toList(),
    );
    return returnResponse<List<Map<String, dynamic>>>(apiResponse, response);
  }
}
