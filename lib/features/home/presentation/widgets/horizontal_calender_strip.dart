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
  late PageController _pageController;
  late DateTime _initialStartDate;
  final int _initialPage = 1000;

  DateTime _getStartDateOfWeek(DateTime date) {
    while (date.weekday != DateTime.saturday) {
      date = date.subtract(const Duration(days: 1));
    }
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _initialStartDate = _getStartDateOfWeek(DateTime.now());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context);
    var langCode = context.locale.toString();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: widget.selectedDateNotifier,
          builder: (context, value, child) => SizedBox(
            height: 70.h,
            child: PageView.builder(
              scrollDirection: .horizontal,
              controller: _pageController,
              itemBuilder: (context, index) {
                final int weekOffset = index - _initialPage;
                final DateTime weekStartDate = _initialStartDate.add(
                  Duration(days: weekOffset * 7),
                );
                return Row(
                  mainAxisAlignment: .center,
                  children: List.generate(7, (dayIndex) {
                    final date = weekStartDate.add(Duration(days: dayIndex));
                    final isTheSameDay = DateUtils.isSameDay(
                      date,
                      widget.selectedDateNotifier.value,
                    );
                    final int habitsCount = context
                        .read<HomeCubit>()
                        .getHabitsCountForDay(date.weekday);
                    return GestureDetector(
                      onTap: () {
                        if (!isTheSameDay) {
                          widget.selectedDateNotifier.value = date;
                          context.read<HomeCubit>().getHabitsByDate(date);
                        }
                      },
                      child: Container(
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: isTheSameDay
                              ? AppColors.surface(context)
                              : Colors.transparent,
                          borderRadius: .circular(16.r),
                          border: isTheSameDay
                              ? null
                              : .all(color: Colors.transparent),
                        ),
                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              DateFormat('E', langCode).format(date),
                              style: isTheSameDay
                                  ? AppTextStyles.font14SemiBoldCustomColor(
                                      AppColors.primary(context),
                                    )
                                  : AppTextStyles.font14CustomColor(
                                      AppColors.textSecondary(context),
                                    ),
                            ),
                            Gap(6.h),
                            Text(
                              DateFormat('d', langCode).format(date),
                              style: AppTextStyles.font18SemiBold(context),
                            ),
                            Gap(4.h),
                            if (habitsCount > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  habitsCount > 3 ? 3 : habitsCount,
                                  (dotIndex) => Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 1.5.w,
                                    ),
                                    width: 5.w,
                                    height: 5.w,
                                    decoration: BoxDecoration(
                                      color: isTheSameDay
                                          ? AppColors.primary(context)
                                          : AppColors.textSecondary(
                                              context,
                                            ).withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Gap(5.w),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
