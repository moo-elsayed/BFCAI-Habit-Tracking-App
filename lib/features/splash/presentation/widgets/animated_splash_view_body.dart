import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/generated/assets.dart';
import '../managers/splash_cubit.dart';

class AnimatedSplashViewBody extends StatelessWidget {
  const AnimatedSplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          context.pushReplacementNamed(Routes.appSection);
        } else if (state is SplashNavigateToLogin) {
          context.pushReplacementNamed(Routes.loginView);
        } else if (state is SplashNavigateToOnboarding) {
          context.pushReplacementNamed(Routes.onboardingView);
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Gap(118.h),
            ElasticIn(
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(Assets.imagesAppLogo, height: 200.h),
            ),
          ],
        ),
      ),
    );
  }
}
