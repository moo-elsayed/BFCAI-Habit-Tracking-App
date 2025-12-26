import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/widgets/app_dialogs.dart';
import 'package:habit_tracking_app/core/widgets/app_toasts.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import 'package:habit_tracking_app/features/home/presentation/widgets/habits_list_view.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/no_results_found_widget.dart';
import '../widgets/horizontal_calendar_strip.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ValueNotifier<DateTime> _selectedDateNotifier;
  List<HabitTrackingEntity> _habits = [];

  String _getTitle(String langCode) =>
      DateUtils.isSameDay(_selectedDateNotifier.value, DateTime.now())
      ? "today".tr()
      : DateFormat(
          langCode == "ar" ? 'd MMM' : 'MMM d',
          langCode,
        ).format(_selectedDateNotifier.value);

  @override
  void initState() {
    super.initState();
    _selectedDateNotifier = ValueNotifier(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getAllHabits(_selectedDateNotifier.value);
    });
  }

  @override
  void dispose() {
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var langCode = context.locale.toString();
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _selectedDateNotifier,
          builder: (context, value, child) =>
              CustomAppBar(title: _getTitle(langCode)),
        ),
        Gap(16.h),
        HorizontalCalendarStrip(selectedDateNotifier: _selectedDateNotifier),
        Gap(16.h),
        Expanded(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeLoading && state.process == .create) {
                AppDialogs.showLoadingDialog(context);
              }
              if (state is HomeSuccess &&
                  (state.process == .getHabitsByDate ||
                      state.process == .create ||
                      state.process == .edit)) {
                if (state.process == .create) {
                  context.pop();
                }
                _habits = state.habits!;
              }
              if (state is HomeFailure) {
                if (state.process == .create) {
                  context.pop();
                }
                if (state.message == "unauthorized_error".tr()) {
                  AppToast.showToast(
                    context: context,
                    title: "session_expired".tr(),
                    type: .error,
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.loginView,
                    (route) => false,
                  );
                } else {
                  AppToast.showToast(
                    context: context,
                    title: state.message,
                    type: .error,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is HomeInitial) {
                return const SizedBox.shrink();
              }
              if (state is HomeLoading &&
                  (state.process == .getHabitsByDate ||
                      state.process == .getAllHabits)) {
                return HabitsListView(
                  isLoading: true,
                  selectedDateNotifier: _selectedDateNotifier,
                );
              }
              if (_habits.isEmpty) {
                return NoResultsFoundWidget(
                  title: "no_habits_found".tr(),
                  bottomGap: 100.h,
                );
              }
              return HabitsListView(
                habits: _habits,
                selectedDateNotifier: _selectedDateNotifier,
              );
            },
          ),
        ),
      ],
    );
  }
}
