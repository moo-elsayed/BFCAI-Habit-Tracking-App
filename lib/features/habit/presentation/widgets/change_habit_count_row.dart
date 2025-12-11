import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_type_switch.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import 'change_habit_count_bottom_sheet.dart';

class ChangeHabitCountRow extends StatelessWidget {
  const ChangeHabitCountRow({
    super.key,
    required this.selectedHabitType,
    required this.colorNotifier,
    required this.countNotifier,
  });

  final ValueNotifier<HabitType> selectedHabitType;
  final ValueNotifier<Color> colorNotifier;
  final ValueNotifier<int> countNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedHabitType,
      builder: (context, type, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInBack,
          transitionBuilder: (Widget child, Animation<double> animation) =>
              SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: FadeTransition(opacity: animation, child: child),
              ),
          child: type == .count
              ? Container(
                  key: const ValueKey("CountOption"),
                  padding: .only(top: 16.h),
                  child: Row(
                    spacing: 16.w,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ValueListenableBuilder(
                          valueListenable: colorNotifier,
                          builder: (context, color, child) => Container(
                            height: 40.h,
                            alignment: .center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: .circular(8.r),
                              border: .all(color: color),
                            ),
                            child: ValueListenableBuilder(
                              valueListenable: countNotifier,
                              builder: (context, value, child) => Text(
                                "$value ${"times".tr()}",
                                style: AppTextStyles.font16WhiteSemiBold(
                                  context,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ChangeHabitCountBottomSheet(
                                initialCount: countNotifier.value,
                                onCountChanged: (value) {
                                  countNotifier.value = value;
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 40.h,
                            alignment: .center,
                            decoration: BoxDecoration(
                              color: AppColors.habitCardColor(context),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "change".tr(),
                              style: TextStyle(
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey("EmptyOption")),
        );
      },
    );
  }
}
