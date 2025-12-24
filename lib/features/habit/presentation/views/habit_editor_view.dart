import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/helpers/validator.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/core/widgets/app_toasts.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/core/widgets/custom_material_button.dart';
import 'package:habit_tracking_app/core/widgets/text_form_field_helper.dart';
import 'package:habit_tracking_app/features/habit/presentation/managers/habit_cubit/habit_cubit.dart';
import 'package:habit_tracking_app/features/habit/presentation/view_utils/habit_form_helper.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/change_habit_count_row.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/customize_habit_row.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_reminders.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_repeat_days.dart';
import 'package:habit_tracking_app/features/habit/presentation/widgets/habit_type_switch.dart';
import '../../../../core/entities/habit_entity.dart';

class HabitEditorView extends StatefulWidget {
  const HabitEditorView({super.key, this.habit});

  final HabitEntity? habit;

  @override
  State<HabitEditorView> createState() => _HabitEditorViewState();
}

class _HabitEditorViewState extends State<HabitEditorView> {
  late final HabitFormHelper _habitFormHelper;

  @override
  void initState() {
    super.initState();
    _habitFormHelper = HabitFormHelper(widget.habit);
  }

  @override
  void dispose() {
    _habitFormHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.habit == null ? "add_habit".tr() : "edit_habit".tr(),
        showArrowBack: true,
        onTap: () => context.pop(),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        behavior: .opaque,
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Gap(16.h),
              Form(
                key: _habitFormHelper.formKey,
                child: TextFormFieldHelper(
                  controller: _habitFormHelper.nameController,
                  labelText: "habit_name".tr(),
                  keyboardType: TextInputType.text,
                  onValidate: Validator.validateName,
                  action: TextInputAction.done,
                ),
              ),
              Gap(24.h),
              CustomizeHabitRow(
                colorNotifier: _habitFormHelper.colorNotifier,
                iconNotifier: _habitFormHelper.iconNotifier,
              ),
              Gap(24.h),
              Text(
                "set_goal".tr(),
                style: AppTextStyles.font18SemiBold(context),
              ),
              Gap(8.h),
              HabitTypeSwitch(
                selectedType: _habitFormHelper.typeNotifier,
                colorNotifier: _habitFormHelper.colorNotifier,
                countNotifier: _habitFormHelper.countNotifier,
              ),
              ChangeHabitCountRow(
                countNotifier: _habitFormHelper.countNotifier,
                colorNotifier: _habitFormHelper.colorNotifier,
                selectedHabitType: _habitFormHelper.typeNotifier,
              ),
              Gap(24.h),
              HabitRepeatDays(
                selectedDays: _habitFormHelper.daysNotifier,
                colorNotifier: _habitFormHelper.colorNotifier,
              ),
              Gap(24.h),
              HabitReminders(
                reminders: _habitFormHelper.remindersNotifier,
                countNotifier: _habitFormHelper.countNotifier,
              ),
              Gap(24.h),
              BlocConsumer<HabitCubit, HabitState>(
                listener: (context, state) {
                  if (state is HabitSuccess) {
                    HabitProcess process = state.process;
                    if (process == .add || process == .edit) {
                      AppToast.showToast(
                        context: context,
                        title: process == .add
                            ? "habit_added_successfully".tr()
                            : "habit_updated_successfully".tr(),
                        type: .success,
                      );
                      context.pop(process == .add ? true : _habitFormHelper.entity);
                    }
                  }
                  if (state is HabitFailure) {
                    HabitProcess process = state.process;
                    if (process == .add || process == .edit) {
                      AppToast.showToast(
                        context: context,
                        title: state.message,
                        type: .error,
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                    valueListenable: _habitFormHelper.colorNotifier,
                    builder: (context, value, child) => CustomMaterialButton(
                      onPressed: () {
                        if (_habitFormHelper.isValid) {
                          if (widget.habit != null) {
                            context.read<HabitCubit>().editHabit(
                              _habitFormHelper.entity,
                            );
                            return;
                          }
                          context.read<HabitCubit>().addHabit(
                            _habitFormHelper.entity,
                          );
                        }
                      },
                      text: "save".tr(),
                      maxWidth: true,
                      color: value,
                      isLoading:
                          state is HabitLoading &&
                          (state.process == HabitProcess.add ||
                              state.process == HabitProcess.edit),
                      textStyle: AppTextStyles.font16WhiteSemiBold(context),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
