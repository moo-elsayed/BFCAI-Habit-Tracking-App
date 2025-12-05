import 'package:flutter/cupertino.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';

import '../../features/auth/presentation/presentation/views/email_verification_view.dart';
import '../../features/auth/presentation/presentation/views/login_view.dart';
import '../../features/auth/presentation/presentation/views/register_view.dart';
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
        return CupertinoPageRoute(
          builder: (context) => LoginView(),
        );
      case Routes.registerView:
        return CupertinoPageRoute(builder: (context) => const RegisterView());
      case Routes.emailVerificationView:
        return CupertinoPageRoute(builder: (context) => const EmailVerificationView());
      // case Routes.forgetPasswordView:
      //   return CupertinoPageRoute(
      //     builder: (context) => const ForgetPasswordView(),
      //   );
      // case Routes.appSection:
      //   return CupertinoPageRoute(builder: (context) => const AppSection());
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
