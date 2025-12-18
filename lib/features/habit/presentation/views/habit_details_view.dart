import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracking_app/core/entities/bottom_sheet_selection_item_entity.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/habit/presentation/args/habit_details_args.dart';

import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../generated/assets.dart';

class HabitDetailsView extends StatefulWidget {
  const HabitDetailsView({super.key, required this.habitDetailsArgs});

  final HabitDetailsArgs habitDetailsArgs;

  @override
  State<HabitDetailsView> createState() => _HabitDetailsViewState();
}

class _HabitDetailsViewState extends State<HabitDetailsView> {
  late ValueNotifier<bool> _animationNotifier;

  @override
  void initState() {
    super.initState();
    _animationNotifier = ValueNotifier<bool>(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationNotifier.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ValueListenableBuilder(
            valueListenable: _animationNotifier,
            builder: (context, value, child) => AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              top: value ? -200.h : -500.h,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 700.w,
                height: 906.h,
                decoration: BoxDecoration(
                  color: getColor(widget.habitDetailsArgs.habitEntity.color),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 50,
            start: 20,
            end: 20,
            child: Row(
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
                          habitEntity: widget.habitDetailsArgs.habitEntity,
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
            ),
          ),
        ],
      ),
    );
  }
}
