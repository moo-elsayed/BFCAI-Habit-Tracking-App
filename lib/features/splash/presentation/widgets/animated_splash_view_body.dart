import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/generated/assets.dart';

class AnimatedSplashViewBody extends StatefulWidget {
  const AnimatedSplashViewBody({super.key});

  @override
  State<AnimatedSplashViewBody> createState() => _AnimatedSplashViewBodyState();
}

class _AnimatedSplashViewBodyState extends State<AnimatedSplashViewBody> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.pushReplacementNamed(Routes.onboardingView);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
