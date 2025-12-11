import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';

class ApiDatabaseService implements DatabaseService {
  ApiDatabaseService(this._dio);

  final Dio _dio;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async => await _dio.post(path, data: data);

  @override
  Future<void> deleteData({required String path, String? id}) async =>
      _dio.delete(path);

  @override
  Future<List<Map<String, dynamic>>> getAllData(String path) async {
    // TODO: implement getAllData
    final response = await _dio.get(path);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  }) {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  Future<void> updateData({
    required String path,
    String? id,
    required Map<String, dynamic> data,
  }) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
