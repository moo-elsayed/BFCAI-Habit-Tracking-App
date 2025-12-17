import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
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
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    } else {
      throwDioException(response, apiResponse);
    }
    return "";
  }

  @override
  Future<String> deleteData({required String path, required int id}) async {
    final response = await _dio.delete("$path/$id");
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    }
    throwDioException(response, apiResponse);
    return "";
  }

  @override
  Future<List<Map<String, dynamic>>> getAllData(String path) async {
    final response = await _dio.get(path);
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => e as Map<String, dynamic>).toList(),
    );
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    }
    throwDioException(response, apiResponse);
    return [];
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
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    }
    throwDioException(response, apiResponse);
    return {};
  }

  @override
  Future<String> updateData({
    required String path,
    int? id,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.put(path, data: data);
    var apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    }
    throwDioException(response, apiResponse);
    return "";
  }
}
