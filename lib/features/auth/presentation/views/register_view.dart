import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/register_cubit/register_cubit.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/email_verification_args.dart';
import 'package:habit_tracking_app/features/auth/presentation/widgets/custom_auth_app_bar.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../../../../../core/widgets/custom_material_button.dart';
import '../../../../../core/widgets/text_form_field_helper.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../view_utils/register_form_helper.dart';
import '../widgets/auth_redirect_text.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterFormHelper _registerFormHelper;

  @override
  void initState() {
    super.initState();
    _registerFormHelper = RegisterFormHelper();
  }

  @override
  void dispose() {
    _registerFormHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(getIt.get<RegisterUseCase>()),
      child: Scaffold(
        appBar: CustomAuthAppBar(
          title: "new_account".tr(),
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
            child: Form(
              key: _registerFormHelper.formKey,
              child: Column(
                children: [
                  Gap(24.h),
                  TextFormFieldHelper(
                    controller: _registerFormHelper.fullNameController,
                    hint: "full_name".tr(),
                    keyboardType: TextInputType.name,
                    onValidate: Validator.validateName,
                    action: TextInputAction.next,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _registerFormHelper.usernameController,
                    hint: "user_name".tr(),
                    keyboardType: TextInputType.name,
                    onValidate: Validator.validateUserName,
                    action: TextInputAction.next,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _registerFormHelper.emailController,
                    hint: "email".tr(),
                    keyboardType: TextInputType.emailAddress,
                    onValidate: Validator.validateEmail,
                    action: TextInputAction.next,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _registerFormHelper.passwordController,
                    hint: "password".tr(),
                    isPassword: true,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.visiblePassword,
                    onValidate: Validator.validatePassword,
                    action: TextInputAction.done,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _registerFormHelper.confirmPasswordController,
                    hint: "confirm_password".tr(),
                    isPassword: true,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.visiblePassword,
                    onValidate: (value) => Validator.validateConfirmPassword(
                      value,
                      _registerFormHelper.passwordController.text,
                    ),
                    action: TextInputAction.done,
                  ),
                  Gap(33.h),
                  BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterSuccess) {
                        AppToast.showToast(
                          context: context,
                          title: "email_created".tr(),
                          type: .success,
                        );
                        var emailVerificationArgs = EmailVerificationArgs(
                          email: _registerFormHelper.emailController.text,
                          password: _registerFormHelper.passwordController.text,
                        );
                        context.pushNamedAndRemoveUntil(
                          Routes.emailVerificationView,
                          arguments: emailVerificationArgs,
                          predicate: (route) => false,
                        );
                      }
                      if (state is RegisterFailure) {
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
                          if (_registerFormHelper.isValid) {
                            context.read<RegisterCubit>().register(
                              _registerFormHelper.getValues(),
                            );
                          }
                        },
                        maxWidth: true,
                        isLoading: state is RegisterLoading,
                        text: "register".tr(),
                        textStyle: AppTextStyles.font16WhiteSemiBold(context),
                      );
                    },
                  ),
                  Gap(33.h),
                  AuthRedirectText(
                    question: "already_have_an_account".tr(),
                    action: "login".tr(),
                    onTap: () => context.pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
