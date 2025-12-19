import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/enums.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/habit/presentation/args/habit_details_args.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_details_progress_card.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../widgets/habit_details_top_actions.dart';

class HabitDetailsView extends StatefulWidget {
  const HabitDetailsView({super.key, required this.habitDetailsArgs});

  final HabitDetailsArgs habitDetailsArgs;

  @override
  State<HabitDetailsView> createState() => _HabitDetailsViewState();
}

class _HabitDetailsViewState extends State<HabitDetailsView> {
  late ValueNotifier<bool> _animationNotifier;
  late ValueNotifier<HabitTrackingEntity> _habitTrackingNotifier;

  // late ValueNotifier<bool> _firstTimeToUpdateValue;

  @override
  void initState() {
    super.initState();
    _habitTrackingNotifier = ValueNotifier<HabitTrackingEntity>(
      widget.habitDetailsArgs.habitTrackingEntity,
    );
    // _firstTimeToUpdateValue = ValueNotifier<bool>(true);
    _animationNotifier = ValueNotifier<bool>(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationNotifier.value = true;
    });
  }

  @override
  void dispose() {
    _habitTrackingNotifier.dispose();
    // _firstTimeToUpdateValue.dispose();
    _animationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 700.w,
                height: 906.h,
                decoration: BoxDecoration(
                  color: getColor(widget.habitDetailsArgs.habitEntity.color),
                  shape: BoxShape.circle,
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
                    HabitDetailsProgressCard(habit: value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
