import 'package:flutter/material.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/login_input_entity.dart';

class LoginFormHelper {
  LoginFormHelper()
    : formKey = GlobalKey<FormState>(),
      emailController = TextEditingController(),
      passwordController = TextEditingController();

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

  void setValues(LoginInputEntity loginInputEntity) {
    emailController.text = loginInputEntity.email;
    passwordController.text = loginInputEntity.password;
  }

  LoginInputEntity getValues() => LoginInputEntity(
    email: emailController.text,
    password: passwordController.text,
  );
}
