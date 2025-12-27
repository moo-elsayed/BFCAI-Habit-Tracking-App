import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';

class LoginResponseModel {
  LoginResponseModel({
    this.email,
    this.userName,
    this.roles,
    this.token,
    this.refreshToken,
    this.refreshTokenExpiration,
  });

  final String? email;
  final String? userName;
  final List<String>? roles;
  final String? token;
  final String? refreshToken;
  final DateTime? refreshTokenExpiration;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        email: json['email'] as String?,
        userName: json['userName'] as String?,
        roles: (json['roles'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        token: json['token'] as String?,
        refreshToken: json['refreshToken'] as String?,
        refreshTokenExpiration: json['refreshTokenExpiration'] != null
            ? DateTime.tryParse(json['refreshTokenExpiration'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'email': email,
    'userName': userName,
    'roles': roles,
    'token': token,
    'refreshToken': refreshToken,
    'refreshTokenExpiration': refreshTokenExpiration?.toIso8601String(),
  };

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      token: token ?? '',
      refreshToken: refreshToken ?? '',
      username: userName ?? '',
      email: email ?? '',
      roles: roles ?? [],
      refreshTokenExpiration: refreshTokenExpiration ?? DateTime.now(),
    );
  }
}
