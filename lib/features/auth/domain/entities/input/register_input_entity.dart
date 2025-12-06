class RegisterInputEntity {
  RegisterInputEntity({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  final String fullName;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
}
