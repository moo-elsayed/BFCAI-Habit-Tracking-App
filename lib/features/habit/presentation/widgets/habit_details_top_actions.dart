import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import '../../../../core/entities/bottom_sheet_selection_item_entity.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../generated/assets.dart';

class HabitDetailsTopActions extends StatelessWidget {
  const HabitDetailsTopActions({super.key, required this.habitEntity});

  final HabitEntity habitEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: SvgPicture.asset(Assets.iconsIconCancel),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext sheetContext) => CustomBottomSheet(
                title: "actions".tr(),
                items: getActionItems(
                  context: context,
                  habitEntity: habitEntity,
                ),
              ),
            );
          },
          child: Transform.rotate(
            angle: isArabic(context) ? 0 : pi,
            child: Image.asset(Assets.iconsMenuIcon, height: 24.sp),
          ),
        ),
      ],
    );
  }
}
