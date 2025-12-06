class LoginResponseEntity {
  LoginResponseEntity({
    this.token = '',
    this.refreshToken = '',
    this.username = '',
    this.email = '',
    this.roles = const <String>[],
  });

  final String token;
  final String refreshToken;
  final String username;
  final String email;
  final List<String> roles;
}
