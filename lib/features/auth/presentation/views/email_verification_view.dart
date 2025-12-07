import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/core/widgets/custom_material_button.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/confirm_email_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/confirm_email_cubit/confirm_email_cubit.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/email_verification_args.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/login_args.dart';
import 'package:habit_tracking_app/features/auth/presentation/widgets/otp_verification_field.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_toasts.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key, required this.emailVerificationArgs});

  final EmailVerificationArgs emailVerificationArgs;

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  late TextEditingController _otpController;

  void _confirmEmail(BuildContext context, String value) =>
      context.read<ConfirmEmailCubit>().confirmEmail(
        ConfirmEmailInputEntity(
          email: widget.emailVerificationArgs.email,
          code: value,
        ),
      );

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
    return BlocProvider(
      create: (context) => ConfirmEmailCubit(getIt.get<ConfirmEmailUseCase>()),
      child: Scaffold(
        appBar: CustomAppBar(title: "email_verification".tr()),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: .symmetric(horizontal: 16.w),
            child: Builder(
              builder: (context) {
                return Column(
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
                      widget.emailVerificationArgs.email,
                      style: AppTextStyles.font12Grey(context),
                    ),
                    Gap(30.h),
                    OtpVerificationField(
                      controller: _otpController,
                      onCompleted: (value) {
                        _confirmEmail(context, value);
                      },
                    ),
                    Gap(30.h),
                    BlocConsumer<ConfirmEmailCubit, ConfirmEmailState>(
                      listener: (context, state) {
                        if (state is ConfirmEmailSuccess) {
                          AppToast.showToast(
                            context: context,
                            title: "email_verified_successfully".tr(),
                            type: .success,
                          );
                          var loginArgs = LoginArgs(
                            email: widget.emailVerificationArgs.email,
                            password: widget.emailVerificationArgs.password,
                          );
                          context.pushNamedAndRemoveUntil(
                            Routes.loginView,
                            arguments: loginArgs,
                            predicate: (route) => false,
                          );
                        }
                        if (state is ConfirmEmailFailure) {
                          AppToast.showToast(
                            context: context,
                            title: state.errorMessage,
                            type: .error,
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomMaterialButton(
                          onPressed: () {
                            if (_otpController.text.length == 6) {
                              _confirmEmail(context, _otpController.text);
                            }
                          },
                          maxWidth: true,
                          text: "check_the_code".tr(),
                          isLoading: state is ConfirmEmailLoading,
                          textStyle: AppTextStyles.font16WhiteSemiBold(context),
                        );
                      },
                    ),
                    // Gap(24.h),
                    // Text(
                    //   "resend_code".tr(),
                    //   style: AppTextStyles.font14CustomColor(
                    //     AppColors.primary(context),
                    //   ),
                    // ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
