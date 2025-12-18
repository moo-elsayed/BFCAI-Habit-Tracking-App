import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/routing/app_router.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/theming/managers/theme_cubit/theme_cubit.dart';
import 'package:habit_tracking_app/habit_tracker.dart';
import 'package:habit_tracking_app/simple_bloc_observer.dart';
import 'core/helpers/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  setupServiceLocator();
  await Future.wait([EasyLocalization.ensureInitialized(), getIt.allReady()]);

  runApp(
    BlocProvider(
      create: (context) =>
          ThemeCubit(getIt.get<AppPreferencesService>())..getCurrentTheme(),
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
