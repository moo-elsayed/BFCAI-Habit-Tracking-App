import 'package:flutter/material.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/presentation/view_utils/args/login_args.dart';

class LoginFormHelper {
  LoginFormHelper()
    : formKey = GlobalKey<FormState>(),
      emailController = .new(),
      passwordController = .new();

  GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  bool get isValid => formKey.currentState!.validate();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  void setValues(LoginArgs loginArgs) {
    emailController.text = loginArgs.email;
    passwordController.text = loginArgs.password;
  }

  LoginInputEntity getValues() => LoginInputEntity(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );
}
