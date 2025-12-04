import 'package:easy_localization/easy_localization.dart';
import '../../../../generated/assets.dart';

class OnboardingEntity {
  OnboardingEntity({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;
}

List<OnboardingEntity> get onboardingSlides => [
  OnboardingEntity(
    image: Assets.svgsOnboardingImage1,
    title: "onboarding_title_1".tr(),
    description: "onboarding_desc_1".tr(),
  ),
  OnboardingEntity(
    image: Assets.svgsOnboardingImage2,
    title: "onboarding_title_2".tr(),
    description: "onboarding_desc_2".tr(),
  ),
  OnboardingEntity(
    image: Assets.svgsOnboardingImage3,
    title: "onboarding_title_3".tr(),
    description: "onboarding_desc_3".tr(),
  ),
];
