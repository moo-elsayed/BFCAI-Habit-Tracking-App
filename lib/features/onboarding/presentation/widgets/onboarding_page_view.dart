import 'package:flutter/material.dart';
import 'package:habit_tracking_app/features/onboarding/presentation/widgets/page_view_item.dart';

import '../../domain/entities/onboarding_entity.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.slides,
    this.onPageChanged, required this.pageController,
  });

  final PageController pageController;
  final List<OnboardingEntity> slides;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) => PageView.builder(
    controller: pageController,
    itemCount: slides.length,
    onPageChanged: onPageChanged,
    itemBuilder: (context, index) => PageViewItem(
      slide: slides[index],
    ),
  );
}
