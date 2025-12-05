import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/generated/assets.dart';

import '../../../auth/presentation/presentation/views/login_view.dart';
import '../../../onboarding/presentation/views/onboarding_view.dart';
import '../managers/splash_cubit.dart';

class AnimatedSplashViewBody extends StatefulWidget {
  const AnimatedSplashViewBody({super.key});

  @override
  State<AnimatedSplashViewBody> createState() => _AnimatedSplashViewBodyState();
}

class _AnimatedSplashViewBodyState extends State<AnimatedSplashViewBody> {
  void navigate(Widget view) => Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => view,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().checkAppStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        // if (state is SplashNavigateToHome) {
        //   navigate(const AppSection());
        // } else
        if (state is SplashNavigateToLogin) {
          navigate(const LoginView());
        } else if (state is SplashNavigateToOnboarding) {
          navigate(const OnboardingView());
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
