import 'package:flutter/material.dart';

class SettingsTileEntity {
  SettingsTileEntity({
    required this.title,
    required this.icon,
    this.isDestructive = false,
    this.trailing,
    this.onTap,
  });

  final String title;
  final bool isDestructive;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
}
