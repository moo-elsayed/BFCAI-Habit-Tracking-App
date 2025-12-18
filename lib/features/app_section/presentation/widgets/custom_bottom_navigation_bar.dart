import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../domain/entities/bottom_navigation_bar_entity.dart';
import 'custom_bottom_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  final ValueChanged<int> onItemTapped;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: .topCenter,
      clipBehavior: .none,
      children: [
        Container(
          height: 56.h,
          alignment: .center,
          decoration: BoxDecoration(
            color: AppColors.background(context),
            borderRadius: .only(
              topLeft: .circular(30),
              topRight: .circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary(context).withValues(alpha: .1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: .spaceAround,
            children: bottomNavigationBarItems.asMap().entries.map((entry) {
              final index = entry.key;
              final entity = entry.value;
              return index == 1
                  ? SizedBox(width: 40.w)
                  : CustomBottomNavigationItem(
                      onTap: () => onItemTapped(index),
                      entity: entity,
                      active: index == selectedIndex,
                    );
            }).toList(),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => onItemTapped(1),
            behavior: .opaque,
            child: Container(
              padding: .all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primary(context),
                shape: .circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary(context).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                bottomNavigationBarItems[1].icon,
                color: Colors.white,
                size: 30.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
