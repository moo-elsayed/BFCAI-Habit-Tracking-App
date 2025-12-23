import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/email_verification_args.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/login_args.dart';
import 'package:habit_tracking_app/features/habit/domain/use_cases/get_habit_history_use_case.dart';
import 'package:habit_tracking_app/features/habit/presentation/views/habit_editor_view.dart';
import 'package:habit_tracking_app/features/habit/presentation/views/habit_details_view.dart';
import '../../features/app_section/presentation/views/app_section.dart';
import '../../features/auth/presentation/views/email_verification_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/habit/domain/use_cases/add_habit_use_case.dart';
import '../../features/habit/domain/use_cases/delete_habit_use_case.dart';
import '../../features/habit/domain/use_cases/edit_habit_use_case.dart';
import '../../features/habit/presentation/args/habit_details_args.dart';
import '../../features/habit/presentation/managers/habit_cubit/habit_cubit.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';
import '../entities/habit_entity.dart';
import '../helpers/di.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashView:
        return _navigate(const AnimatedSplashView());
      case Routes.onboardingView:
        return _navigate(const OnboardingView());
      case Routes.loginView:
        var args = arguments as LoginArgs?;
        return _navigate(LoginView(loginArgs: args));
      case Routes.registerView:
        return _navigate(const RegisterView());
      case Routes.emailVerificationView:
        var args = arguments as EmailVerificationArgs;
        return _navigate(EmailVerificationView(emailVerificationArgs: args));
      case Routes.appSection:
        return _navigate(const AppSection());
      case Routes.habitDetailsView:
        var args = arguments as HabitDetailsArgs;
        return _navigate(
          BlocProvider(
            create: (context) => HabitCubit(
              getIt.get<AddHabitUseCase>(),
              getIt.get<DeleteHabitUseCase>(),
              getIt.get<EditHabitUseCase>(),
              getIt.get<GetHabitHistoryUseCase>(),
            ),
            child: HabitDetailsView(habitDetailsArgs: args),
          ),
        );
      case Routes.habitEditorView:
        var args = arguments as HabitEntity?;
        return _navigate(
          BlocProvider(
            create: (context) => HabitCubit(
              getIt.get<AddHabitUseCase>(),
              getIt.get<DeleteHabitUseCase>(),
              getIt.get<EditHabitUseCase>(),
              getIt.get<GetHabitHistoryUseCase>(),
            ),
            child: HabitEditorView(habit: args),
          ),
        );
      default:
        return null;
    }
  }

  PageRouteBuilder<dynamic> _navigate(Widget view) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => view,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}
