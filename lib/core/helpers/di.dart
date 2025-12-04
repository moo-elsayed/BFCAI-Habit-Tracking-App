import 'package:get_it/get_it.dart';

import '../../shared_data/local_storage_service/shared_preferences_manager.dart';
import '../services/local_storage/local_storage_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  /// local storage service
  getIt.registerSingletonAsync<LocalStorageService>(() async {
    final service = SharedPreferencesManager();
    await service.init();
    return service;
  });
}
