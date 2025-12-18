import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_tracking_app/core/services/auth_service/auth_service.dart';
import 'package:habit_tracking_app/core/services/database_service/database_service.dart';
import 'package:habit_tracking_app/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:habit_tracking_app/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/confirm_email_use_case.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:habit_tracking_app/features/habit/data/data_sources/remote/habit_remote_data_source_imp.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/add_habit_use_case.dart';
import 'package:habit_tracking_app/features/home/data/data_sources/remote/home_remote_data_source_imp.dart';
import 'package:habit_tracking_app/features/home/data/repo_imp/home_repo_imp.dart';
import 'package:habit_tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/create_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/edit_habit_tracking_use_case.dart';
import 'package:habit_tracking_app/features/home/domain/use_cases/get_tracked_habits_by_date_use_case.dart';
import 'package:habit_tracking_app/shared_data/services/auth_service/api_auth_service.dart';
import 'package:habit_tracking_app/shared_data/services/database_service/api_database_service.dart';
import '../../features/auth/domain/use_cases/clear_user_session_use_case.dart';
import '../../features/auth/domain/use_cases/save_user_session_use_case.dart';
import '../../features/habit/data/repo_imp/habit_repo_imp.dart';
import '../../features/habit/domain/repo/habit_repo.dart';
import '../../features/habit/domain/use_cases/delete_habit_use_case.dart';
import '../../features/habit/domain/use_cases/edit_habit_use_case.dart';
import '../../features/home/domain/use_cases/get_all_habits_use_case.dart';
import '../../shared_data/services/local_storage_service/secure_storage_manager.dart';
import '../../shared_data/services/local_storage_service/shared_preferences_manager.dart';
import '../services/auth_service/auth_interceptor.dart';
import '../services/local_storage/app_preferences_service.dart';
import '../services/local_storage/auth_storage_service.dart';
import 'api_constants.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  /// App Preferences Service
  getIt.registerSingletonAsync<AppPreferencesService>(() async {
    final service = SharedPreferencesManager();
    await service.init();
    return service;
  });

  /// App Storage Service
  getIt.registerLazySingleton<AuthStorageService>(() => SecureStorageManager());

  /// dio
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      receiveDataWhenStatusError: true,
    ),
  );

  dio.interceptors.add(AuthInterceptor(dio, getIt<AuthStorageService>()));

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );

  /// Database Service
  getIt.registerSingleton<DatabaseService>(ApiDatabaseService(dio));

  /// Auth Interceptor
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(dio, getIt.get<SecureStorageManager>()),
  );

  /// Auth
  getIt.registerSingleton<AuthService>(ApiAuthService(dio));

  getIt.registerLazySingleton<SaveUserSessionUseCase>(
    () => SaveUserSessionUseCase(
      getIt<AppPreferencesService>(),
      getIt.get<AuthStorageService>(),
    ),
  );

  getIt.registerLazySingleton<ClearUserSessionUseCase>(
    () => ClearUserSessionUseCase(
      getIt<AppPreferencesService>(),
      getIt.get<AuthStorageService>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(
      AuthRemoteDataSourceImp(
        getIt.get<AuthService>(),
        getIt.get<AuthStorageService>(),
      ),
    ),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt.get<AuthRepo>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt.get<AuthRepo>(),
      getIt.get<SaveUserSessionUseCase>(),
    ),
  );

  getIt.registerLazySingleton<ConfirmEmailUseCase>(
    () => ConfirmEmailUseCase(getIt.get<AuthRepo>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      getIt.get<AuthRepo>(),
      getIt.get<ClearUserSessionUseCase>(),
    ),
  );

  /// Habit

  getIt.registerLazySingleton<HabitRepo>(
    () => HabitRepoImp(HabitRemoteDataSourceImp(getIt.get<DatabaseService>())),
  );

  getIt.registerLazySingleton<AddHabitUseCase>(
    () => AddHabitUseCase(getIt.get<HabitRepo>()),
  );

  getIt.registerLazySingleton<DeleteHabitUseCase>(
    () => DeleteHabitUseCase(getIt.get<HabitRepo>()),
  );

  getIt.registerLazySingleton<EditHabitUseCase>(
    () => EditHabitUseCase(getIt.get<HabitRepo>()),
  );

  /// Home

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImp(HomeRemoteDataSourceImp(getIt.get<DatabaseService>())),
  );

  getIt.registerLazySingleton<GetAllHabitsUseCase>(
    () => GetAllHabitsUseCase(getIt.get<HomeRepo>()),
  );

  getIt.registerLazySingleton<GetTrackedHabitsByDateUseCase>(
    () => GetTrackedHabitsByDateUseCase(getIt.get<HomeRepo>()),
  );

  getIt.registerLazySingleton<CreateHabitTrackingUseCase>(
    () => CreateHabitTrackingUseCase(getIt.get<HomeRepo>()),
  );

  getIt.registerLazySingleton<EditHabitTrackingUseCase>(
    () => EditHabitTrackingUseCase(getIt.get<HomeRepo>()),
  );
}
