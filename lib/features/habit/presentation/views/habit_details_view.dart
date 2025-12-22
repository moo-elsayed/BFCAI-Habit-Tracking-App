import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/enums.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
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
    });
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
    return MultiBlocListener(
      listeners: [
        BlocListener<HabitCubit, HabitState>(
          listener: (context, state) {
            if (state is HabitSuccess && (state.process == .delete)) {
              AppToast.showToast(
                context: context,
                title: "deleted".tr(),
                type: .success,
              );
              context.pop(true);
            }
            if (state is HabitFailure && (state.process == .delete)) {
              AppToast.showToast(
                context: context,
                title: state.message,
                type: .error,
              );
            }
          },
        ),
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
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
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.pop(_isDataChanged);
        },
        child: Scaffold(
          body: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: .none,
            children: [
              ValueListenableBuilder(
                valueListenable: _animationNotifier,
                builder: (context, value, child) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  top: value ? -200.h : -300.h,
                  child: ValueListenableBuilder(
                    valueListenable: _habitTrackingNotifier,
                    builder: (context, value, child) => Container(
                      alignment: Alignment.bottomCenter,
                      width: 700.w,
                      height: 906.h,
                      decoration: BoxDecoration(
                        color: getColor(value.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 50,
                start: 20,
                end: 20,
                child: HabitDetailsTopActions(
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
                    if (updatedHabit != null && updatedHabit is HabitEntity) {
                      _isDataChanged = true;
                      _habitNotifier.value = updatedHabit;
                      _habitTrackingNotifier.value = _habitTrackingNotifier
                          .value
                          .copyWith(
                            name: updatedHabit.name,
                            icon: updatedHabit.icon,
                            color: updatedHabit.color,
                            type: updatedHabit.type,
                            targetValue: updatedHabit.targetValue,
                          );
                    }
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _habitTrackingNotifier,
                builder: (context, value, child) => Padding(
                  padding: .only(top: 110.h),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: .all(8.r),
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
                          style: AppTextStyles.font14Regular(
                            context,
                          ).copyWith(fontSize: 16.sp, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _animationNotifier,
                builder: (context, animationValue, child) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  top: animationValue ? 310.h : 400.h,
                  right: 28.w,
                  left: 28.w,
                  child: ValueListenableBuilder(
                    valueListenable: _habitTrackingNotifier,
                    builder: (context, value, child) =>
                        HabitDetailsProgressCard(
                          habit: value,
                          onValueUpdated: (value) {
                            _habitTrackingNotifier.value = value;
                            _isDataChanged = true;
                          },
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
