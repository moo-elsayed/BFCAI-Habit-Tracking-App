import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import '../../../../../../core/theming/app_colors.dart';
import '../../../../../../core/theming/app_text_styles.dart';

class ChangeHabitCountBottomSheet extends StatefulWidget {
  const ChangeHabitCountBottomSheet({
    super.key,
    required this.onCountChanged,
    required this.initialCount,
  });

  final ValueChanged<int> onCountChanged;
  final int initialCount;

  @override
  State<ChangeHabitCountBottomSheet> createState() =>
      _ChangeHabitCountBottomSheetState();
}

class _ChangeHabitCountBottomSheetState
    extends State<ChangeHabitCountBottomSheet> {
  late ValueNotifier<int> _countNotifier;

  void _increment() => _countNotifier.value++;

  void _decrement() {
    if (_countNotifier.value > 1) {
      _countNotifier.value--;
    }
  }

  @override
  void initState() {
    super.initState();
    _countNotifier = ValueNotifier(widget.initialCount);
  }

  @override
  void dispose() {
    _countNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: .only(
          topRight: .circular(20.r),
          topLeft: .circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "set_daily_goal".tr(),
            style: AppTextStyles.font18SemiBold(context),
          ),
          Gap(32.h),
          ValueListenableBuilder(
            valueListenable: _countNotifier,
            builder: (context, value, child) => Row(
              mainAxisAlignment: .center,
              spacing: 32.w,
              children: [
                _buildCounterButton(
                  icon: CupertinoIcons.minus,
                  onTap: _decrement,
                  isEnabled: value > 1,
                  context: context,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$value',
                    key: ValueKey<int>(_countNotifier.value),
                    style: AppTextStyles.font32Bold(context).copyWith(
                      fontSize: 48.sp,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                _buildCounterButton(
                  icon: CupertinoIcons.add,
                  onTap: _increment,
                  isEnabled: true,
                  context: context,
                  isPrimary: true,
                ),
              ],
            ),
          ),
          Gap(16.h),
          Text("times_per_day".tr(), style: AppTextStyles.font14Grey(context)),
          Gap(40.h),
          SizedBox(
            width: .infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                widget.onCountChanged(_countNotifier.value);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
                elevation: 0,
              ),
              child: Text(
                "save".tr(),
                style: AppTextStyles.font16WhiteSemiBold(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
    required BuildContext context,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary(context)
              : AppColors.habitCardColor(context),
          borderRadius: .circular(16.r),
          boxShadow: isEnabled && isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.primary(context).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: isPrimary
              ? Colors.white
              : (isEnabled
                    ? AppColors.textPrimary(context)
                    : AppColors.textSecondary(context).withValues(alpha: 0.3)),
          size: 28.sp,
        ),
      ),
    );
  }
}
