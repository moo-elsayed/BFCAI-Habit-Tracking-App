import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_arrow_bar.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAuthAppBar({
    super.key,
    required this.title,
    this.showArrowBack = false,
    this.centerTitle = true,
    this.onTap,
  });

  final String title;
  final bool showArrowBack;
  final VoidCallback? onTap;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showArrowBack
          ? Padding(
              padding: EdgeInsetsDirectional.only(start: 16.w),
              child: CustomArrowBack(onTap: onTap),
            )
          : null,
      leadingWidth: showArrowBack ? 52.w : 0,
      title: Text(title, style: AppTextStyles.font18SemiBold(context)),
      backgroundColor: AppColors.background(context),
      centerTitle: centerTitle,
    );
  }
}
