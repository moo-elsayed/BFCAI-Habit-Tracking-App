import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheetTopContainer extends StatelessWidget {
  const CustomBottomSheetTopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 4.h,
      margin: .only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.5),
        borderRadius: .circular(16),
      ),
    );
  }
}
