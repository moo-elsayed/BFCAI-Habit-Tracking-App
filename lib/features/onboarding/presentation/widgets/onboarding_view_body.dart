import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../managers/onboarding_cubit/onboarding_cubit.dart';
import 'onboarding_page_view.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;
  List<OnboardingEntity> slides = onboardingSlides;

  String _getButtonText(int index) =>
      index == slides.length - 1 ? "get_started".tr() : "next".tr();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndexNotifier = ValueNotifier(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: OnboardingPageView(
            pageController: _pageController,
            slides: slides,
            onPageChanged: (index) {
              _currentIndexNotifier.value = index;
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: slides.length,
          axisDirection: Axis.horizontal,
          effect: ExpandingDotsEffect(
            spacing: 8.w,
            radius: 8.r,
            dotWidth: 12.w,
            dotHeight: 12.h,
            paintStyle: .fill,
            dotColor: AppColors.textSecondary(context),
            activeDotColor: AppColors.primary(context),
          ),
        ),
        Padding(
          padding: .only(top: 29.h, bottom: 43.h, right: 16.w, left: 16.w),
          child: BlocListener<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingNavigateToHome) {
                context.pushReplacementNamed(Routes.loginView);
              }
            },
            child: ValueListenableBuilder(
              valueListenable: _currentIndexNotifier,
              builder: (context, value, child) => CustomMaterialButton(
                onPressed: () {
                  if (value == slides.length - 1) {
                    context.read<OnboardingCubit>().setFirstTime(false);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                maxWidth: true,
                text: _getButtonText(value),
                textStyle: AppTextStyles.font16WhiteSemiBold(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
