import 'package:habit_tracking_app/core/services/database_service/query_parameters.dart';

abstract class DatabaseService {
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  });

  Future<List<Map<String, dynamic>>> getAllData(String path);

  Future<List<Map<String, dynamic>>> queryData({
    required String path,
    QueryParameters? query,
  });

  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<String> updateData({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
  });

  Future<String> deleteData({required String path, required int id});
}
