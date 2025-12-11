import 'package:flutter/cupertino.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/email_verification_args.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/login_args.dart';
import 'package:habit_tracking_app/features/habit/presentation/views/add_or_edit_habit_view.dart';
import 'package:habit_tracking_app/features/habit/presentation/views/habit_details_view.dart';
import '../../features/app_section/presentation/views/app_section.dart';
import '../../features/auth/presentation/views/email_verification_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashView:
        return CupertinoPageRoute(
          builder: (context) => const AnimatedSplashView(),
        );
      case Routes.onboardingView:
        return CupertinoPageRoute(builder: (context) => const OnboardingView());
      case Routes.loginView:
        var args = arguments as LoginArgs?;
        return CupertinoPageRoute(
          builder: (context) => LoginView(loginArgs: args),
        );
      case Routes.registerView:
        return CupertinoPageRoute(builder: (context) => const RegisterView());
      case Routes.emailVerificationView:
        var args = arguments as EmailVerificationArgs;
        return CupertinoPageRoute(
          builder: (context) =>
              EmailVerificationView(emailVerificationArgs: args),
        );
      case Routes.appSection:
        return CupertinoPageRoute(builder: (context) => const AppSection());
      case Routes.habitDetailsView:
        return CupertinoPageRoute(builder: (context) => const HabitDetailsView());
      case Routes.addOrEditHabitView:
        return CupertinoPageRoute(builder: (context) => const AddOrEditHabitView());
      // case Routes.home:
      //   return CupertinoPageRoute(builder: (context) => const Home());
      // case Routes.forgetPasswordView:
      //   return CupertinoPageRoute(
      //     builder: (context) => const ForgetPasswordView(),
      //   );
      // case Routes.searchView:
      //   return CupertinoPageRoute(builder: (context) => const SearchView());
      // case Routes.productDetailsView:
      //   final view_utils = arguments as FruitEntity;
      //   return CupertinoPageRoute(
      //     builder: (context) => ProductDetailsView(fruitEntity: view_utils),
      //   );
      // case Routes.checkoutView:
      //   final view_utils = arguments as List<CartItemEntity>;
      //   return CupertinoPageRoute(
      //     builder: (context) => CheckoutView(cartItems: view_utils),
      //   );
      default:
        return null;
    }
  }
}
