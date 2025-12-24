import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../domain/entities/onboarding_entity.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, required this.slide});

  final OnboardingEntity slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(slide.image),
        Padding(
          padding: .only(bottom: 43.h, right: 24.w, left: 24.w),
          child: Column(
            spacing: 16.h,
            children: [
              Text(slide.title, style: AppTextStyles.font24Bold(context)),
              Text(
                slide.description,
                textAlign: .center,
                style: AppTextStyles.font14Regular(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
