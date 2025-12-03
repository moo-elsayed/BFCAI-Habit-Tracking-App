import 'package:flutter/cupertino.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      // case Routes.splashView:
      //   return CupertinoPageRoute(
      //     builder: (context) => const AnimatedSplashView(),
      //   );
      // case Routes.onboardingView:
      //   return CupertinoPageRoute(builder: (context) => const OnboardingView());
      // case Routes.loginView:
      //   final args = arguments as LoginArgs?;
      //   return CupertinoPageRoute(
      //     builder: (context) => LoginView(loginArgs: args),
      //   );
      // case Routes.registerView:
      //   return CupertinoPageRoute(builder: (context) => const RegisterView());
      // case Routes.forgetPasswordView:
      //   return CupertinoPageRoute(
      //     builder: (context) => const ForgetPasswordView(),
      //   );
      // case Routes.appSection:
      //   return CupertinoPageRoute(builder: (context) => const AppSection());
      // case Routes.searchView:
      //   return CupertinoPageRoute(builder: (context) => const SearchView());
      // case Routes.productDetailsView:
      //   final args = arguments as FruitEntity;
      //   return CupertinoPageRoute(
      //     builder: (context) => ProductDetailsView(fruitEntity: args),
      //   );
      // case Routes.checkoutView:
      //   final args = arguments as List<CartItemEntity>;
      //   return CupertinoPageRoute(
      //     builder: (context) => CheckoutView(cartItems: args),
      //   );
      default:
        return null;
    }
  }
}
