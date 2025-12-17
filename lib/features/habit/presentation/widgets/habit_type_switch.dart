import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theming/app_colors.dart';
import '../../../../../../core/theming/app_text_styles.dart';
import '../../../../core/entities/habit_entity.dart';

class HabitTypeSwitch extends StatelessWidget {
  const HabitTypeSwitch({
    super.key,
    required this.colorNotifier,
    required this.selectedType,
    required this.countNotifier,
  });

  final ValueNotifier<HabitType> selectedType;
  final ValueNotifier<Color> colorNotifier;
  final ValueNotifier<int> countNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      padding: .all(6.r),
      decoration: BoxDecoration(
        color: AppColors.habitCardColor(context),
        borderRadius: .circular(8.r),
        border: .all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ValueListenableBuilder(
        valueListenable: selectedType,
        builder: (context, value, child) => Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: selectedType.value == .task
                  ? AlignmentDirectional.bottomStart
                  : AlignmentDirectional.bottomEnd,
              child: ValueListenableBuilder(
                valueListenable: colorNotifier,
                builder: (context, value, child) => FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: value,
                      borderRadius: .circular(6.r),
                      boxShadow: [
                        BoxShadow(
                          color: value.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _buildOption(context: context, type: .task, title: "task".tr()),
                _buildOption(
                  context: context,
                  type: .count,
                  title: "count".tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required HabitType type,
    required String title,
  }) {
    final bool isSelected = selectedType.value == type;
    return Expanded(
      child: GestureDetector(
        behavior: .opaque,
        onTap: () {
          selectedType.value = type;
          if (type == .task) {
            Future.delayed(const Duration(milliseconds: 200), () {
              countNotifier.value = 1;
            });
          } else {
            countNotifier.value = 3;
          }
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: isSelected
                ? AppTextStyles.font16WhiteSemiBold(context)
                : AppTextStyles.font16PrimarySemiBold(context).copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: .w500,
                  ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
