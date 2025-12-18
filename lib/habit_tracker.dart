import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/routing/app_router.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/core/theming/managers/theme_cubit/theme_cubit.dart';
import 'core/theming/app_theme.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  ThemeMode currentMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, state) {
          if (state is ThemeChanged) {
            currentMode = state.themeMode;
          }
        },
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            themeMode: currentMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            onGenerateRoute: widget.appRouter.generateRoute,
            initialRoute: Routes.splashView,
          );
        },
      ),
    );
  }
}
