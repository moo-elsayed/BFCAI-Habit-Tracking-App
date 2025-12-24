import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/features/home/presentation/widgets/horizontal_calendar_strip_item.dart';
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
                    final List<Color> colors = context
                        .read<HomeCubit>()
                        .getHabitsColorsForDay(date.weekday);
                    return GestureDetector(
                      onTap: () {
                        if (!isTheSameDay) {
                          widget.selectedDateNotifier.value = date;
                          context.read<HomeCubit>().getHabitsByDate(date);
                        }
                      },
                      child: HorizontalCalendarStripItem(
                        isTheSameDay: isTheSameDay,
                        langCode: langCode,
                        date: date,
                        colors: colors,
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
