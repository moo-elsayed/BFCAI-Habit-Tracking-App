import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/habit_history_entity.dart';

class HabitHistoryCalendar extends StatefulWidget {
  const HabitHistoryCalendar({
    super.key,
    required this.historyData,
    required this.baseColor,
    this.currentHabit,
    required this.selectedDate,
  });

  final List<HabitHistoryEntity> historyData;
  final Color baseColor;
  final HabitTrackingEntity? currentHabit;
  final DateTime selectedDate;

  @override
  State<HabitHistoryCalendar> createState() => _HabitHistoryCalendarState();
}

class _HabitHistoryCalendarState extends State<HabitHistoryCalendar> {
  late Map<DateTime, HabitHistoryEntity> _events;
  DateTime _focusedDay = DateTime.now();

  @override
  void didUpdateWidget(covariant HabitHistoryCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.historyData != oldWidget.historyData ||
        widget.currentHabit != oldWidget.currentHabit) {
      setState(() {
        _events = _groupHistoryByDate(widget.historyData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _events = _groupHistoryByDate(widget.historyData);
  }

  Map<DateTime, HabitHistoryEntity> _groupHistoryByDate(
    List<HabitHistoryEntity> data,
  ) {
    Map<DateTime, HabitHistoryEntity> dataMap = {};
    for (var item in data) {
      final dateKey = DateTime.utc(
        item.date.year,
        item.date.month,
        item.date.day,
      );
      dataMap[dateKey] = item;
    }

    if (widget.currentHabit != null) {
      final date = widget.selectedDate;
      final dateKey = DateTime.utc(date.year, date.month, date.day);

      dataMap[dateKey] = HabitHistoryEntity(
        date: date,
        currentValue: widget.currentHabit!.trackingRecordEntity.currentValue,
        targetValue: widget.currentHabit!.targetValue,
      );
    }

    return dataMap;
  }

  HabitHistoryEntity? _getEventForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: .circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TableCalendar(
        locale: context.locale.toString(),
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        currentDay: DateTime.now(),
        headerStyle: HeaderStyle(
          headerPadding: .only(bottom: 4.h),
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTextStyles.font14Grey(
            context,
          ).copyWith(fontSize: 16.sp),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: 24.sp,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: 24.sp,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          outsideTextStyle: AppTextStyles.font14Grey(
            context,
          ),
          todayDecoration: BoxDecoration(
            color: widget.baseColor.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: AppColors.textSecondary(context)),
        ),
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayCell(day);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, isToday: true);
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, {bool isToday = false}) {
    final historyItem = _getEventForDay(day);
    if (historyItem == null || historyItem.currentValue == 0) {
      return Center(
        child: Container(
          width: 35.w,
          height: 35.h,
          decoration: isToday
              ? BoxDecoration(
                  border: Border.all(color: widget.baseColor, width: 2),
                  shape: BoxShape.circle,
                )
              : null,
          child: Center(
            child: Text(
              '${day.day}',
              style: isToday
                  ? AppTextStyles.font14CustomColor(widget.baseColor)
                  : AppTextStyles.font14Regular(context),
            ),
          ),
        ),
      );
    }
    bool isCompleted = historyItem.currentValue >= historyItem.targetValue;
    return Center(
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          color: isCompleted
              ? widget.baseColor
              : widget.baseColor.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
      ),
    );
  }
}
