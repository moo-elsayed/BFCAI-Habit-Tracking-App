import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  AuthRepoImp(this._authRemoteDataSource);

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<NetworkResponse<String>> register(RegisterInputEntity input) async =>
      await _authRemoteDataSource.register(input);

  @override
  Future<NetworkResponse<LoginResponseEntity>> login(
    LoginInputEntity input,
  ) async => await _authRemoteDataSource.login(input);

  @override
  Future<NetworkResponse<String>> confirmEmail(
    ConfirmEmailInputEntity input,
  ) async => await _authRemoteDataSource.confirmEmail(input);

  @override
  Future<NetworkResponse<String>> logout() async =>
      await _authRemoteDataSource.logout();
}
