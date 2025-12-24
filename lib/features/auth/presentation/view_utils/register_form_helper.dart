import 'package:flutter/material.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';

class RegisterFormHelper {
  RegisterFormHelper()
    : formKey = GlobalKey<FormState>(),
      fullNameController = .new(),
      usernameController = .new(),
      emailController = .new(),
      passwordController = .new(),
      confirmPasswordController = .new();

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
    fullName: fullNameController.text.trim(),
    username: usernameController.text.trim(),
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
    confirmPassword: confirmPasswordController.text.trim(),
  );
}
