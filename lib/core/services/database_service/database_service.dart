abstract class DatabaseService {
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  });

  Future<List<Map<String, dynamic>>> getAllData(String path);

  Future<void> addData({
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
