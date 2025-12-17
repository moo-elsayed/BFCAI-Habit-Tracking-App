abstract class DatabaseService {
  Future<Map<String, dynamic>> getData({
    required String path,
    required String id,
  });

  Future<List<Map<String, dynamic>>> getAllData(String path);

  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<String> updateData({
    required String path,
    int? id,
    required Map<String, dynamic> data,
  });

  Future<String> deleteData({required String path, required int id});
}
