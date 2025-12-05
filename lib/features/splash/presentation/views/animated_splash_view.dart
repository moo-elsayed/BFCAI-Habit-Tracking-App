import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/services/local_storage/local_storage_service.dart';
import 'package:habit_tracking_app/features/splash/presentation/managers/splash_cubit.dart';
import 'package:habit_tracking_app/features/splash/presentation/widgets/animated_splash_view_body.dart';
import 'package:habit_tracking_app/generated/assets.dart';

class AnimatedSplashView extends StatelessWidget {
  const AnimatedSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SplashCubit(getIt.get<LocalStorageService>()),
        child: AnimatedSplashViewBody(),
      ),
      bottomNavigationBar: FadeInUp(
        delay: const Duration(milliseconds: 1000),
        duration: const Duration(milliseconds: 1000),
        child: Column(
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Image.asset(Assets.imagesBrandingImage, height: 90.h),
            Gap(50.h),
          ],
        ),
      ),
    );
  }
}
