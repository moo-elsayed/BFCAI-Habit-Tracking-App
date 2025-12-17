import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/services/auth_service/auth_service.dart';
import 'package:habit_tracking_app/features/auth/data/models/input/confirm_email_input_model.dart';
import 'package:habit_tracking_app/features/auth/data/models/input/login_input_model.dart';
import 'package:habit_tracking_app/features/auth/data/models/input/register_input_model.dart';
import 'package:habit_tracking_app/features/auth/data/models/response/login_response_model.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/shared_data/models/api_response/api_response.dart';
import '../../../core/helpers/api_constants.dart';
import '../../../core/helpers/functions.dart';

class ApiAuthService implements AuthService {
  ApiAuthService(this._dio);

  final Dio _dio;

  @override
  Future<String> register(RegisterInputEntity input) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: RegisterInputModel.fromEntity(input).toJson(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );

    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    } else {
      throwDioException(response, apiResponse);
    }
    return "";
  }

  @override
  Future<LoginResponseEntity> login(LoginInputEntity input) async {
    final response = await _dio.post(
      ApiConstants.login,
      queryParameters: LoginInputModel.fromEntity(input).toJson(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) =>
          LoginResponseModel.fromJson(json as Map<String, dynamic>).toEntity(),
    );

    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    } else {
      throwDioException(response, apiResponse);
    }
    return LoginResponseEntity();
  }

  @override
  Future<String> confirmEmail(ConfirmEmailInputEntity input) async {
    final response = await _dio.get(
      ApiConstants.confirmEmail,
      queryParameters: ConfirmEmailInputModel.fromEntity(input).toJson(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    } else {
      throwDioException(response, apiResponse);
    }
    return "";
  }

  @override
  Future<String> logout(String token) async {
    final response = await _dio.post(
      ApiConstants.revokeToken,
      data: {"token": token},
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
    if (apiResponse.isSuccess) {
      return apiResponse.data!;
    } else {
      throwDioException(response, apiResponse);
    }
    return "";
  }
}
