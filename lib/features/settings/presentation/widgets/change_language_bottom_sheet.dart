import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/widgets/custom_divider.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_sheet_top_container.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';

class ChangeLanguageBottomSheet extends StatelessWidget {
  const ChangeLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          const CustomBottomSheetTopContainer(),
          Text(
            "select_language".tr(),
            style: AppTextStyles.font16PrimarySemiBold(context),
          ),
          Gap(16.h),
          buildListTile(
            context: context,
            isChecked: isArabic(context),
            title: "العربية",
            langCode: "ar",
          ),
          const CustomDivider(),
          buildListTile(
            context: context,
            isChecked: !isArabic(context),
            title: "English",
            langCode: "en",
          ),
        ],
      ),
    );
  }

  ListTile buildListTile({
    required BuildContext context,
    required String title,
    required bool isChecked,
    required String langCode,
  }) => ListTile(
    onTap: () {
      context.pop();
      showCupertinoDialog(
        context: context,
        builder: (context) => CustomConfirmationDialog(
          title: "confirm_language_change".tr(),
          subtitle: "app_will_restart".tr(),
          textConfirmButton: "ok".tr(),
          textCancelButton: "cancel".tr(),
          onConfirm: () async {
            context.pop();
            await context.setLocale(Locale(langCode));
            Restart.restartApp();
          },
        ),
      );
    },
    visualDensity: .compact,
    title: Text(title, style: AppTextStyles.font13Medium(context)),
    trailing: isChecked ? const Icon(Icons.check, color: Colors.green) : null,
  );
}
