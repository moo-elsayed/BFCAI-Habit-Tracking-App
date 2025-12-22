import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../generated/assets.dart';
import '../theming/app_text_styles.dart';

class NoResultsFoundWidget extends StatelessWidget {
  const NoResultsFoundWidget({
    super.key,
    required this.title,
    required this.bottomGap,
  });

  final String title;
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        SvgPicture.asset(Assets.svgsNoResultsFound, height: 300.h),
        Text(title, style: AppTextStyles.font16PrimarySemiBold(context)),
        Gap(bottomGap),
      ],
    );
  }
}
