import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/enums.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/habit/domain/entities/get_habit_history_input_entity.dart';
import 'package:habit_tracking_app/features/habit/presentation/args/habit_details_args.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_details_progress_card.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../managers/habit_cubit/habit_cubit.dart';
import '../widgets/habit_details_top_actions.dart';
import '../widgets/habit_history_calendar.dart';

class HabitDetailsView extends StatefulWidget {
  const HabitDetailsView({super.key, required this.habitDetailsArgs});

  final HabitDetailsArgs habitDetailsArgs;

  @override
  State<HabitDetailsView> createState() => _HabitDetailsViewState();
}

class _HabitDetailsViewState extends State<HabitDetailsView> {
  late ValueNotifier<bool> _animationNotifier;
  late ValueNotifier<HabitEntity> _habitNotifier;
  late ValueNotifier<HabitTrackingEntity> _habitTrackingNotifier;
  bool _isDataChanged = false;

  @override
  void initState() {
    super.initState();
    _habitNotifier = ValueNotifier<HabitEntity>(
      widget.habitDetailsArgs.habitEntity,
    );
    _habitTrackingNotifier = ValueNotifier<HabitTrackingEntity>(
      widget.habitDetailsArgs.habitTrackingEntity,
    );
    _animationNotifier = ValueNotifier<bool>(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationNotifier.value = true;
      _getHabitHistory();
    });
  }

  void _getHabitHistory() {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 90));

    context.read<HabitCubit>().getHabitHistory(
      GetHabitHistoryInputEntity(
        habitId: _habitNotifier.value.id!,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  void dispose() {
    _habitNotifier.dispose();
    _habitTrackingNotifier.dispose();
    _animationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // if (state is HomeSuccess &&
        //     (state.process == .edit || state.process == .create)) {
        //   _getHabitHistory();
        // }
        if (state is HomeSuccess && state.process == .create) {
          final updatedList = state.habits;
          if (updatedList != null) {
            final myHabit = updatedList.firstWhere(
              (h) => h.habitId == widget.habitDetailsArgs.habitEntity.id,
              orElse: () => _habitTrackingNotifier.value,
            );
            if (myHabit.trackingRecordEntity.trackingId != null) {
              _habitTrackingNotifier.value = myHabit;
            }
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.pop(_isDataChanged);
        },
        child: Scaffold(
          body: BlocListener<HabitCubit, HabitState>(
            listener: (context, state) {
              if (state is HabitSuccess && (state.process == .delete)) {
                AppToast.showToast(
                  context: context,
                  title: "deleted".tr(),
                  type: .success,
                );
                context.pop(true);
              }
              if (state is HabitFailure) {
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
                  if (state.process == .delete) {
                    AppToast.showToast(
                      context: context,
                      title: state.message,
                      type: .error,
                    );
                  }
                }
              }
            },
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: .none,
              children: [
                ValueListenableBuilder(
                  valueListenable: _animationNotifier,
                  builder: (context, value, child) => AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    top: value ? -300.h : -400.h,
                    child: ValueListenableBuilder(
                      valueListenable: _habitTrackingNotifier,
                      builder: (context, value, child) => Container(
                        alignment: Alignment.bottomCenter,
                        width: 1000.w,
                        height: 1000.h,
                        decoration: BoxDecoration(
                          color: getColor(value.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 20.w,
                  left: 20.h,
                  top: 35.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Gap(20.h),
                        HabitDetailsTopActions(
                          habitEntity: widget.habitDetailsArgs.habitEntity,
                          onDelete: () async {
                            bool confirmation = false;
                            await showCupertinoDialog(
                              context: context,
                              builder: (context) => CustomConfirmationDialog(
                                title: "confirm_habit_deletion".tr(),
                                textConfirmButton: "ok".tr(),
                                textCancelButton: "cancel".tr(),
                                onConfirm: () async {
                                  context.pop();
                                  confirmation = true;
                                },
                              ),
                            );
                            if (confirmation) {
                              context.read<HabitCubit>().deleteHabit(
                                widget.habitDetailsArgs.habitEntity.id!,
                              );
                            }
                          },
                          onEdit: () async {
                            final updatedHabit = await context.pushNamed(
                              Routes.habitEditorView,
                              arguments: _habitNotifier.value,
                            );
                            if (updatedHabit != null &&
                                updatedHabit is HabitEntity) {
                              _isDataChanged = true;
                              _habitNotifier.value = updatedHabit;
                              _habitTrackingNotifier.value =
                                  _habitTrackingNotifier.value.copyWith(
                                    name: updatedHabit.name,
                                    icon: updatedHabit.icon,
                                    color: updatedHabit.color,
                                    type: updatedHabit.type,
                                    targetValue: updatedHabit.targetValue,
                                  );
                            }
                          },
                        ),
                        Gap(30.h),
                        ValueListenableBuilder(
                          valueListenable: _habitTrackingNotifier,
                          builder: (context, value, child) => Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: .all(12.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.textSecondary(
                                      context,
                                    ).withValues(alpha: 0.3),
                                    borderRadius: .circular(12.r),
                                  ),
                                  child: Icon(
                                    IconData(
                                      int.parse(value.icon),
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 60.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                Gap(20.h),
                                Text(
                                  value.name,
                                  style: AppTextStyles.font24Medium(
                                    context,
                                  ).copyWith(color: Colors.black),
                                ),
                                Gap(10.h),
                                Text(
                                  value.type == HabitType.task
                                      ? "task".tr()
                                      : "${value.targetValue} ${"times".tr()}",
                                  style: AppTextStyles.font14Regular(context)
                                      .copyWith(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(30.h),
                        ValueListenableBuilder(
                          valueListenable: _animationNotifier,
                          builder: (context, isVisible, child) {
                            return AnimatedPadding(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              padding: EdgeInsets.only(
                                top: isVisible ? 0 : 100.h,
                              ),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: isVisible ? 1.0 : 0.0,
                                child: Column(
                                  children: [
                                    if (widget.habitDetailsArgs.selectedDate
                                        .isBefore(DateTime.now()))
                                      ValueListenableBuilder(
                                        valueListenable: _habitTrackingNotifier,
                                        builder: (context, value, child) =>
                                            Padding(
                                              padding: .only(bottom: 20.h),
                                              child: HabitDetailsProgressCard(
                                                selectedDate: widget
                                                    .habitDetailsArgs
                                                    .selectedDate,
                                                habit: value,
                                                onValueUpdated: (value) {
                                                  _habitTrackingNotifier.value =
                                                      value;
                                                  _isDataChanged = true;
                                                },
                                              ),
                                            ),
                                      ),
                                    BlocBuilder<HabitCubit, HabitState>(
                                      buildWhen: (previous, current) =>
                                          (current is HabitLoading &&
                                              current.process ==
                                                  HabitProcess
                                                      .getHabitHistory) ||
                                          (current is HabitSuccess &&
                                              current.process ==
                                                  HabitProcess
                                                      .getHabitHistory) ||
                                          (current is HabitFailure &&
                                              current.process ==
                                                  HabitProcess.getHabitHistory),
                                      builder: (context, state) {
                                        if (state is HabitLoading &&
                                            state.process ==
                                                HabitProcess.getHabitHistory) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (state is HabitSuccess &&
                                            state.process ==
                                                HabitProcess.getHabitHistory) {
                                          return ValueListenableBuilder(
                                            valueListenable:
                                                _habitTrackingNotifier,
                                            builder: (context, value, child) =>
                                                HabitHistoryCalendar(
                                                  selectedDate: widget
                                                      .habitDetailsArgs
                                                      .selectedDate,
                                                  currentHabit: value,
                                                  historyData: state.history!,
                                                  baseColor: getColor(
                                                    _habitTrackingNotifier
                                                        .value
                                                        .color,
                                                  ),
                                                ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    Gap(50.h),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
