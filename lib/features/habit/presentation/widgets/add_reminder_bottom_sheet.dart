import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class AddReminderBottomSheet extends StatelessWidget {
  const AddReminderBottomSheet({
    super.key,
    required this.onDateTimeChanged,
    required this.onTap,
  });

  final ValueChanged<DateTime> onDateTimeChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Material(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: .only(
          topLeft: .circular(20.r),
          topRight: .circular(20.r),
        ),
        child: Column(
          children: [
            Padding(
              padding: .only(top: 16.w, right: 16.h, left: 16.w),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    "add_reminder".tr(),
                    style: AppTextStyles.font18SemiBold(
                      context,
                    ).copyWith(color: AppColors.textPrimary(context)),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTap();
                      context.pop();
                    },
                    child: Icon(
                      Icons.check,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  8,
                  0,
                ),
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
