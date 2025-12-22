import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart'
    as FlutterIconPicker;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import 'customize_habit_item.dart';

class CustomizeHabitRow extends StatelessWidget {
  const CustomizeHabitRow({
    super.key,
    required this.colorNotifier,
    required this.iconNotifier,
  });

  final ValueNotifier<Color> colorNotifier;
  final ValueNotifier<IconData> iconNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: iconNotifier,
            builder: (context, value, child) => CustomizeHabitItem(
              onTap: () => _pickIcon(context),
              title: "icon".tr(),
              child: Icon(value, color: AppColors.textPrimary(context)),
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: colorNotifier,
            builder: (context, value, child) => CustomizeHabitItem(
              onTap: () => _selectColorDialog(context, value),
              title: "color".tr(),
              child: DecoratedBox(
                decoration: BoxDecoration(color: value, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickIcon(BuildContext context) async {
    FlutterIconPicker.IconPickerIcon? icon =
        await FlutterIconPicker.showIconPicker(
          context,
          configuration: SinglePickerConfiguration(
            title: Text(
              'pick_an_icon!'.tr(),
              style: AppTextStyles.font18SemiBold(context),
            ),
            iconPickerShape: RoundedRectangleBorder(
              borderRadius: .circular(30.r),
            ),
            searchComparator:
                (String search, FlutterIconPicker.IconPickerIcon icon) =>
                    search.toLowerCase().contains(
                      icon.name.replaceAll('_', ' ').toLowerCase(),
                    ) ||
                    icon.name.toLowerCase().contains(search.toLowerCase()),
            closeChild: Text(
              "close".tr(),
              style: AppTextStyles.font16PrimarySemiBold(context),
            ),
          ),
        );
    if (icon != null) {
      iconNotifier.value = icon.data;
    }
  }

  Future<void> _selectColorDialog(BuildContext context, Color value) async {
    Color myColor = value;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'pick_a_color!'.tr(),
          style: AppTextStyles.font18SemiBold(context),
        ),
        content: Column(
          mainAxisSize: .min,
          children: [
            ColorPicker(
              pickerColor: value,
              onColorChanged: (color) {
                myColor = color;
              },
            ),
          ],
        ),
        actions: [
          CustomMaterialButton(
            onPressed: () {
              colorNotifier.value = myColor;
              context.pop();
            },
            text: "save".tr(),
            textStyle: AppTextStyles.font16WhiteSemiBold(context),
          ),
        ],
      ),
    );
  }
}
