import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/core/widgets/text_form_field_helper.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/change_habit_count_row.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/customize_habit_row.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_type_switch.dart';

class AddOrEditHabitView extends StatefulWidget {
  const AddOrEditHabitView({super.key});

  @override
  State<AddOrEditHabitView> createState() => _AddOrEditHabitViewState();
}

class _AddOrEditHabitViewState extends State<AddOrEditHabitView> {
  late ValueNotifier<HabitType> _selectedHabitType;
  late ValueNotifier<Color> _colorNotifier;
  late ValueNotifier<IconData> _iconNotifier;
  late ValueNotifier<int> _countNotifier;

  @override
  void initState() {
    super.initState();
    _selectedHabitType = ValueNotifier(.task);
    _colorNotifier = ValueNotifier(AppColors.error(context));
    _iconNotifier = ValueNotifier(Icons.sports_basketball);
    _countNotifier = ValueNotifier(3);
  }

  @override
  void dispose() {
    _selectedHabitType.dispose();
    _colorNotifier.dispose();
    _iconNotifier.dispose();
    _countNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "add_habit".tr(),
        showArrowBack: true,
        onTap: () => context.pop(),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Gap(16.h),
              TextFormFieldHelper(
                labelText: "habit_name".tr(),
                keyboardType: TextInputType.text,
                action: TextInputAction.done,
              ),
              Gap(24.h),
              CustomizeHabitRow(
                colorNotifier: _colorNotifier,
                iconNotifier: _iconNotifier,
              ),
              Gap(24.h),
              Text(
                "set_goal".tr(),
                style: AppTextStyles.font18SemiBold(context),
              ),
              Gap(8.h),
              HabitTypeSwitch(
                selectedType: _selectedHabitType,
                colorNotifier: _colorNotifier,
              ),
              ChangeHabitCountRow(
                countNotifier: _countNotifier,
                colorNotifier: _colorNotifier,
                selectedHabitType: _selectedHabitType,
              ),
              Gap(24.h),
              Text("repeat".tr(), style: AppTextStyles.font18SemiBold(context)),
            ],
          ),
        ),
      ),
    );
  }
}
