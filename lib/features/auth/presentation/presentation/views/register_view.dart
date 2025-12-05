import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/presentation/presentation/view_utils/register_form_helper.dart';
import 'package:habit_tracking_app/features/auth/presentation/widgets/custom_auth_app_bar.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../../../../../core/widgets/custom_material_button.dart';
import '../../../../../core/widgets/text_form_field_helper.dart';
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
    return Scaffold(
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
                  controller: _registerFormHelper.fullNameController,
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
                  controller: _registerFormHelper.passwordController,
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
                CustomMaterialButton(
                  onPressed: () {
                    context.pop(
                      LoginInputEntity(
                        email: "elmoosayed@gmail.com",
                        password: "123456",
                      ),
                    );
                    if (_registerFormHelper.isValid) {
                      // context
                      //     .read<SignupCubit>()
                      //     .createUserWithEmailAndPassword(
                      //       username: _nameController.text.trim(),
                      //       email: _emailController.text.trim(),
                      //       password: _passwordController.text.trim(),
                      //     );
                    }
                  },
                  maxWidth: true,
                  // isLoading: state is SignUpLoading,
                  text: "register".tr(),
                  textStyle: AppTextStyles.font16WhiteSemiBold(context),
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
    );
  }
}
