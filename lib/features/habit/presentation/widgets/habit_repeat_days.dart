import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class HabitRepeatDays extends StatelessWidget {
  const HabitRepeatDays({
    super.key,
    required this.selectedDays,
    required this.colorNotifier,
  });

  final ValueNotifier<List<int>> selectedDays;
  final ValueNotifier<Color> colorNotifier;

  void _toggleDay(int index) =>
      selectedDays.value = List.from(selectedDays.value)
        ..[index] = selectedDays.value[index] == 1 ? 0 : 1;

  List<String> get _daysLabels => [
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("repeat".tr(), style: AppTextStyles.font18SemiBold(context)),
            ValueListenableBuilder(
              valueListenable: selectedDays,
              builder: (context, value, child) => GestureDetector(
                behavior: .opaque,
                onTap: () {
                  bool allSelected = selectedDays.value.every(
                    (element) => element == 1,
                  );
                  selectedDays.value = List.generate(
                    7,
                    (index) => allSelected ? 0 : 1,
                  );
                },
                child: Text(
                  selectedDays.value.contains(0)
                      ? "select_all".tr()
                      : "clear_all".tr(),
                  style: AppTextStyles.font12Grey(context).copyWith(
                    color: AppColors.primary(context),
                    fontWeight: .bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(8.h),
        ValueListenableBuilder(
          valueListenable: selectedDays,
          builder: (context, value, child) => Row(
            mainAxisAlignment: .spaceBetween,
            children: List.generate(value.length, (index) {
              bool isSelected = value[index] == 1;
              return GestureDetector(
                onTap: () => _toggleDay(index),
                child: ValueListenableBuilder(
                  valueListenable: colorNotifier,
                  builder: (context, value, child) => Container(
                    width: 40.w,
                    height: 40.h,
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? value
                          : AppColors.habitCardColor(context),
                      borderRadius: .circular(8.r),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: AppColors.textSecondary(
                                context,
                              ).withValues(alpha: 0.1),
                            ),
                    ),
                    child: Text(
                      _daysLabels[index].tr(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary(context),
                        fontWeight: isSelected ? .bold : .normal,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
