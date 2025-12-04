import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/local_storage/local_storage_service.dart';

class SharedPreferencesManager implements LocalStorageService {
  late SharedPreferences _prefs;
  final String _isFirstTimeKey = 'isFirstTime';

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<void> setFirstTime(bool isFirstTime) async =>
      await _prefs.setBool(_isFirstTimeKey, isFirstTime);

  @override
  bool getFirstTime() => _prefs.getBool(_isFirstTimeKey) ?? true;
}
