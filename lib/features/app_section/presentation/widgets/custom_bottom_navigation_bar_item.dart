import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../domain/entities/bottom_navigation_bar_entity.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({
    super.key,
    required this.entity,
    required this.active,
    required this.onTap,
  });

  final BottomNavigationBarEntity entity;
  final bool active;
  final VoidCallback onTap;

  Color _getColor({required BuildContext context, required bool active}) =>
      !active ? AppColors.textSecondary(context) : AppColors.primary(context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: .opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              entity.icon,
              size: 26.r,
              color: _getColor(context: context, active: active),
            ),
            if (active)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
