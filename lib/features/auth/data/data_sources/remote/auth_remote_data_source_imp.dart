import 'package:dio/dio.dart';
import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/core/services/auth_service/auth_service.dart';
import 'package:habit_tracking_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import '../../../../../core/helpers/app_logger.dart';
import '../../../../../core/helpers/failures.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  AuthRemoteDataSourceImp(this._authService);

  final AuthService _authService;

  @override
  Future<NetworkResponse<String>> register(RegisterInputEntity input) async {
    try {
      var apiResponse = await _authService.register(input);
      return NetworkSuccess(apiResponse.data);
    } on DioException catch (e) {
      // return NetworkFailure(Exception(ServerFailure.fromDioException(e)));
      return _handleAuthError(e, "register");
    } catch (e) {
      return _handleAuthError(e, "register");
    }
  }

  @override
  Future<NetworkResponse<LoginResponseEntity>> login(
    LoginInputEntity input,
  ) async {
    try {
      var apiResponse = await _authService.login(input);
      return NetworkSuccess(apiResponse.data);
    } on DioException catch (e) {
      return _handleAuthError(e, "login");
    } catch (e) {
      return _handleAuthError(e, "login");
    }
  }

  @override
  Future<NetworkResponse<String>> confirmEmail(
    ConfirmEmailInputEntity input,
  ) async {
    try {
      var apiResponse = await _authService.confirmEmail(input);
      return NetworkSuccess(apiResponse.data);
    } on DioException catch (e) {
      return _handleAuthError(e, "confirmEmail");
    } catch (e) {
      return _handleAuthError(e, "confirmEmail");
    }
  }

  @override
  Future<NetworkResponse<String>> logout() async {
    try {
      var apiResponse = await _authService.logout();
      return NetworkSuccess(apiResponse.data);
    } on DioException catch (e) {
      return _handleAuthError(e, "logout");
    } catch (e) {
      return _handleAuthError(e, "logout");
    }
  }

  // ------------------------------------------------
  NetworkFailure<T> _handleAuthError<T>(Object e, String functionName) {
    AppLogger.error("error occurred in $functionName", error: e);
    if (e is DioException) {
      return NetworkFailure(
        Exception(ServerFailure.fromDioException(e).errorMessage),
      );
    }
    return NetworkFailure(Exception(e.toString()));
  }
}
