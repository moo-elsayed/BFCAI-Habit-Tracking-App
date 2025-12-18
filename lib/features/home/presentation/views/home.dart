import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/widgets/app_toasts.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import 'package:habit_tracking_app/features/home/presentation/widgets/habits_list_view.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/routing/routes.dart';
import '../widgets/horizontal_calender_strip.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ValueNotifier<DateTime> _selectedDateNotifier;
  List<HabitTrackingEntity> _habits = [];

  @override
  void initState() {
    super.initState();
    _selectedDateNotifier = ValueNotifier(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getHomeHabits(_selectedDateNotifier.value);
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
          builder: (context, value, child) => CustomAppBar(
            title: DateFormat(
              langCode == "ar" ? 'd MMM' : 'MMM d',
              langCode,
            ).format(_selectedDateNotifier.value),
          ),
        ),
        Gap(16.h),
        HorizontalCalendarStrip(selectedDateNotifier: _selectedDateNotifier),
        Gap(16.h),
        Expanded(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeSuccess && state.process == .getHomeHabits) {
                _habits = state.uiHabits!;
              }
              if (state is HomeFailure) {
                if (state.message == "Unauthorized error") {
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
              if (state is HomeLoading && state.process == .getHomeHabits) {
                return const HabitsListView(isLoading: true);
              }
              if (_habits.isEmpty) {
                return const Center(child: Text("No habits found"));
              }
              return HabitsListView(habits: _habits);
            },
          ),
        ),
      ],
    );
  }
}
