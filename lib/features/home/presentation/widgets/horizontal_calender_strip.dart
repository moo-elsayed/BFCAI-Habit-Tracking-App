import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import '../managers/home_cubit/home_cubit.dart';

class HorizontalCalendarStrip extends StatefulWidget {
  const HorizontalCalendarStrip({
    super.key,
    required this.selectedDateNotifier,
  });

  final ValueNotifier<DateTime> selectedDateNotifier;

  @override
  State<HorizontalCalendarStrip> createState() =>
      _HorizontalCalendarStripState();
}

class _HorizontalCalendarStripState extends State<HorizontalCalendarStrip> {
  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _days = List.generate(14, (index) {
      return DateTime.now()
          .subtract(const Duration(days: 3))
          .add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.selectedDateNotifier,
      builder: (context, value, child) => SizedBox(
        height: 70.h,
        child: ListView.separated(
          physics: RangeMaintainingScrollPhysics(),
          scrollDirection: .horizontal,
          padding: .symmetric(horizontal: 16.w),
          itemCount: _days.length,
          separatorBuilder: (context, index) => Gap(12.w),
          itemBuilder: (context, index) {
            final date = _days[index];
            final isTheSameDay = DateUtils.isSameDay(
              date,
              widget.selectedDateNotifier.value,
            );
            return GestureDetector(
              onTap: () {
                if (!isTheSameDay) {
                  widget.selectedDateNotifier.value = date;
                  context.read<HomeCubit>().getHomeHabits(date);
                }
              },
              child: Container(
                width: 45.w,
                decoration: BoxDecoration(
                  color: isTheSameDay
                      ? AppColors.surface(context)
                      : Colors.transparent,
                  borderRadius: .circular(16.r),
                  border: isTheSameDay ? null : .all(color: Colors.transparent),
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: AppTextStyles.font14CustomColor(
                        isTheSameDay
                            ? AppColors.primary(context)
                            : AppColors.textSecondary(context)
                      ),
                    ),
                    Gap(6.h),
                    Text(
                      date.day.toString(),
                      style: AppTextStyles.font18SemiBold(context),
                    ),
                    Gap(4.h),
                    if (isTheSameDay)
                      CircleAvatar(
                        radius: 3.r,
                        backgroundColor: AppColors.primary(context),
                      )
                    else
                      Gap(6.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
