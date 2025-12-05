import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/presentation/presentation/view_utils/login_form_helper.dart';
import 'package:habit_tracking_app/features/auth/presentation/widgets/custom_auth_app_bar.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../../../../../core/widgets/custom_material_button.dart';
import '../../../../../core/widgets/text_form_field_helper.dart';
import '../widgets/auth_redirect_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginFormHelper _loginFormHelper;
  late final ValueNotifier<GlobalKey<FormState>> _notifier = ValueNotifier(
    _loginFormHelper.formKey,
  );

  void _clearForm() {
    _loginFormHelper.clear();
    _loginFormHelper.formKey = GlobalKey<FormState>();
    _notifier.value = _loginFormHelper.formKey;
  }

  Future<void> _navigate({
    required BuildContext context,
    required String routeName,
  }) async {
    final result = await context.pushNamed(routeName);
    if (result != null && result is LoginInputEntity) {
      _loginFormHelper.emailController.text = result.email;
      _loginFormHelper.passwordController.text = result.password;
    } else {
      _clearForm();
    }
  }

  @override
  void initState() {
    super.initState();
    _loginFormHelper = LoginFormHelper();
  }

  @override
  void dispose() {
    _loginFormHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppBar(title: "login".tr(), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
          child: ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, value, child) => Form(
              child: Form(
                key: value,
                child: Column(
                  children: [
                    Gap(24.h),
                    TextFormFieldHelper(
                      controller: _loginFormHelper.emailController,
                      hint: "email".tr(),
                      keyboardType: TextInputType.emailAddress,
                      onValidate: Validator.validateEmail,
                      action: TextInputAction.next,
                    ),
                    Gap(16.h),
                    TextFormFieldHelper(
                      controller: _loginFormHelper.passwordController,
                      hint: "password".tr(),
                      isPassword: true,
                      obscuringCharacter: '●',
                      keyboardType: TextInputType.visiblePassword,
                      onValidate: Validator.validatePassword,
                      action: TextInputAction.done,
                    ),
                    Gap(33.h),
                    CustomMaterialButton(
                      onPressed: () {
                        if (_notifier.value.currentState!.validate()) {
                          // context.read<SignInCubit>().signInWithEmailAndPassword(
                          //     email: _emailController.text.trim(),
                          //     password: _passwordController.text.trim(),
                          // );
                        }
                      },
                      maxWidth: true,
                      text: "login".tr(),
                      textStyle: AppTextStyles.font16WhiteSemiBold(context),
                      // isLoading: state is SignInLoading,
                    ),
                    Gap(33.h),
                    AuthRedirectText(
                      question: "don't_have_account".tr(),
                      action: "create_an_account".tr(),
                      onTap: () async => await _navigate(
                        context: context,
                        routeName: Routes.registerView,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
