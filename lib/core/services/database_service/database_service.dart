import 'package:habit_tracking_app/shared_data/models/api_response/api_response.dart';

abstract class DatabaseService {
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  });

  Future<List<Map<String, dynamic>>> getAllData(String path);

  Future<ApiResponse<String>> addData({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<void> updateData({
    required String path,
    String? id,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({required String path, String? id});
}
