import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/widgets/app_toasts.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/add_reminder_bottom_sheet.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/reminder_item.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class HabitReminders extends StatefulWidget {
  const HabitReminders({
    super.key,
    required this.reminders,
    required this.countNotifier,
  });

  final ValueNotifier<List<DateTime>> reminders;
  final ValueNotifier<int> countNotifier;

  @override
  State<HabitReminders> createState() => _HabitRemindersState();
}

class _HabitRemindersState extends State<HabitReminders> {
  void _showTimePicker() {
    DateTime tempPickedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      8,
      0,
    );
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => AddReminderBottomSheet(
        onTap: () {
          _addReminder(tempPickedDate);
        },
        onDateTimeChanged: (newTime) {
          tempPickedDate = newTime;
        },
      ),
    );
  }

  void _addReminder(DateTime newTime) {
    if (widget.reminders.value.any(
      (t) => t.hour == newTime.hour && t.minute == newTime.minute,
    )) {
      AppToast.showToast(
        context: context,
        title: "reminder_already_exists".tr(),
        type: .error,
      );
      return;
    }
    widget.reminders.value = [...widget.reminders.value, newTime];
  }

  void _removeReminder(int index) =>
      widget.reminders.value = List.from(widget.reminders.value)
        ..removeAt(index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("reminder".tr(), style: AppTextStyles.font18SemiBold(context)),
        Gap(8.h),
        ValueListenableBuilder(
          valueListenable: widget.countNotifier,
          builder: (context, countValue, child) {
            if (widget.reminders.value.length > countValue) {
              widget.reminders.value = widget.reminders.value.sublist(
                0,
                countValue,
              );
            }
            return ValueListenableBuilder(
              valueListenable: widget.reminders,
              builder: (context, remindersValue, child) {
                bool isFull = remindersValue.length >= countValue;
                bool isEmpty = remindersValue.isEmpty;
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.habitCardColor(context),
                        borderRadius: .circular(24.r),
                      ),
                      child: GestureDetector(
                        behavior: .opaque,
                        onTap: () {
                          if (!isFull) {
                            _showTimePicker();
                          } else {
                            AppToast.showToast(
                              context: context,
                              title: "max_reminders_reached".tr(),
                              type: .error,
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 35.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                color:
                                    (!isFull
                                            ? Colors.grey
                                            : AppColors.primary(context))
                                        .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: !isFull
                                    ? Colors.grey
                                    : AppColors.primary(context),
                              ),
                            ),
                            Gap(16.w),
                            Text(
                              isFull
                                  ? "${"all_reminders_set".tr()} (${remindersValue.length}/$countValue)"
                                  : isEmpty
                                  ? "add_reminder".tr()
                                  : "${"add_reminder".tr()} (${remindersValue.length}/$countValue)",
                              style: AppTextStyles.font16PrimarySemiBold(
                                context,
                              ).copyWith(color: AppColors.textPrimary(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (remindersValue.isNotEmpty) ...[
                      Gap(16.w),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(
                          remindersValue.length,
                          (index) => ReminderItem(
                            reminderValue: remindersValue[index],
                            onTap: () => _removeReminder(index),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
