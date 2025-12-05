import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/theming/app_colors.dart';

class OtpVerificationField extends StatelessWidget {
  const OtpVerificationField({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: AppTextStyles.font18SemiBold(context),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        border: .all(color: Colors.grey.shade300),
        borderRadius: .circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: .all(color: AppColors.primary(context), width: 2),
      borderRadius: .circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary(context).withValues(alpha: 0.1),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: .onSubmit,
      showCursor: true,
      onCompleted: (pin) => onCompleted(pin),
    );
  }
}
