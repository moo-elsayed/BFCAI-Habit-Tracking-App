import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../generated/assets.dart';
import '../helpers/extensions.dart';
import '../theming/app_colors.dart';
import '../theming/app_text_styles.dart';
import 'custom_material_button.dart';

class CustomConfirmationDialog extends StatelessWidget {
  const CustomConfirmationDialog({
    super.key,
    this.subtitle,
    required this.textConfirmButton,
    required this.textCancelButton,
    required this.title,
    required this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String? subtitle;
  final String textConfirmButton;
  final String textCancelButton;
  final void Function()? onCancel;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: .all(20.r),
        child: Column(
          mainAxisSize: .min,
          spacing: 12.h,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  Assets.iconsIconCancel,
                  colorFilter: .mode(
                    Theme.of(context).colorScheme.inverseSurface,
                    .srcIn,
                  ),
                ),
              ),
            ),
            Text(
              title,
              textAlign: .center,
              style: AppTextStyles.font16WhiteSemiBold(
                context,
              ).copyWith(color: AppColors.textPrimary(context)),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: .center,
                style: AppTextStyles.font14Regular(context),
              ),
            Gap(8.h),
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: CustomMaterialButton(
                    onPressed: onCancel ?? () => context.pop(),
                    text: textCancelButton,
                    textStyle: AppTextStyles.font16PrimarySemiBold(context),
                    color: Colors.white,
                    side: BorderSide(color: AppColors.primary(context)),
                  ),
                ),
                Expanded(
                  child: CustomMaterialButton(
                    onPressed: onConfirm,
                    text: textConfirmButton,
                    textStyle: AppTextStyles.font16WhiteSemiBold(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
