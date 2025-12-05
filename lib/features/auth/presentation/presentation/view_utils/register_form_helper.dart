import 'package:flutter/material.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/register_input_entity.dart';

class RegisterFormHelper {
  RegisterFormHelper()
    : formKey = GlobalKey<FormState>(),
      fullNameController = TextEditingController(),
      usernameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  late GlobalKey<FormState> formKey;
  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool get isValid => formKey.currentState!.validate();

  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  RegisterInputEntity getValues() => RegisterInputEntity(
    fullName: fullNameController.text,
    username: usernameController.text,
    email: emailController.text,
    password: passwordController.text,
    confirmPassword: confirmPasswordController.text,
  );
}
