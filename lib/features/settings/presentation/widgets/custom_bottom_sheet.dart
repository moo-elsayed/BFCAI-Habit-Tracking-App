import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/features/settings/domain/entities/bottom_sheet_selection_item_entity.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_sheet_top_container.dart';
import 'bottom_sheet_selection_item.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<BottomSheetSelectionItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        spacing: 16.h,
        children: [
          const CustomBottomSheetTopContainer(margin: 0),
          Text(title, style: AppTextStyles.font22Bold(context)),
          ...List.generate(
            items.length,
            (index) => BottomSheetSelectionItem(entity: items[index]),
          ),
        ],
      ),
    );
  }
}
