import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/app_logger.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/core/widgets/custom_material_button.dart';
import 'package:habit_tracking_app/features/auth/presentation/presentation/widgets/otp_verification_field.dart';
import 'package:habit_tracking_app/features/auth/presentation/widgets/custom_auth_app_bar.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppBar(title: "email_verification".tr()),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              Gap(24.h),
              Text(
                "enter_the_code_we_sent_to_the_following_email_address".tr(),
                style: AppTextStyles.font14Regular(context),
              ),
              Gap(8.h),
              Text(
                "elmoosayed@gmail.com",
                style: AppTextStyles.font12Grey(context),
              ),
              Gap(30.h),
              OtpVerificationField(
                controller: _otpController,
                onCompleted: (value) {
                  AppLogger.debug(value);
                },
              ),
              Gap(30.h),
              CustomMaterialButton(
                onPressed: () {
                  if (_otpController.text.length == 6) {
                    AppLogger.debug(_otpController.text);
                  }
                },
                maxWidth: true,
                text: "check_the_code".tr(),
                textStyle: AppTextStyles.font16WhiteSemiBold(context),
              ),
              Gap(24.h),
              Text(
                "resend_code".tr(),
                style: AppTextStyles.font14CustomColor(
                  AppColors.primary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
