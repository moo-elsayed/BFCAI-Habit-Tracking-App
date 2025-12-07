import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';

class CustomCupertinoSwitch extends StatefulWidget {
  const CustomCupertinoSwitch({
    super.key,
    required this.onChanged,
    required this.isChecked,
  });

  final ValueChanged<bool> onChanged;
  final bool isChecked;

  @override
  State<CustomCupertinoSwitch> createState() => _CustomCupertinoSwitchState();
}

class _CustomCupertinoSwitchState extends State<CustomCupertinoSwitch> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      activeTrackColor: AppColors.primary(context),
      inactiveTrackColor: Colors.grey,
      value: _isChecked,
      onChanged: (value) {
        setState(() => _isChecked = value);
        widget.onChanged(value);
      },
    );
  }
}
