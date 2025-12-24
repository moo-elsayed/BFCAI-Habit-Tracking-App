import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/routing/app_router.dart';
import 'package:habit_tracking_app/core/services/local_notification_service/local_notification_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/theming/managers/theme_cubit/theme_cubit.dart';
import 'package:habit_tracking_app/habit_tracker.dart';
import 'package:habit_tracking_app/simple_bloc_observer.dart';
import 'core/helpers/di.dart';
import 'features/home/domain/use_cases/create_habit_tracking_use_case.dart';
import 'features/home/domain/use_cases/edit_habit_tracking_use_case.dart';
import 'features/home/domain/use_cases/get_all_habits_use_case.dart';
import 'features/home/domain/use_cases/get_habits_by_date_use_case.dart';
import 'features/home/presentation/managers/home_cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    LocalNotificationService.init(),
    setupServiceLocator(),
    getIt.allReady(),
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ThemeCubit(getIt.get<AppPreferencesService>())..getCurrentTheme(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(
            getIt.get<GetAllHabitsUseCase>(),
            getIt.get<GetHabitsByDateUseCase>(),
            getIt.get<CreateHabitTrackingUseCase>(),
            getIt.get<EditHabitTrackingUseCase>(),
            getIt.get<AppPreferencesService>(),
          ),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: [const Locale('ar'), const Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        saveLocale: true,
        child: HabitTracker(appRouter: AppRouter()),
      ),
    ),
  );
}
