import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class Failure {
  final String errorMessage;

  const Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errorMessage: 'connection_timeout'.tr());

      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: 'send_timeout'.tr());

      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: 'receive_timeout'.tr());

      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: 'bad_certificate'.tr());

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure(errorMessage: 'request_canceled'.tr());

      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: 'no_internet_connection'.tr());

      case DioExceptionType.unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return ServerFailure(errorMessage: 'no_internet_connection'.tr());
        }
        return ServerFailure(errorMessage: 'unexpected_error'.tr());
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (response == null) {
      return ServerFailure(errorMessage: 'unknown_error'.tr());
    }
    if (response is Map<String, dynamic>) {
      if (response['message'] != null &&
          response['message'].toString().isNotEmpty) {
        return ServerFailure(errorMessage: response['message']);
      }
      if (response['errors'] != null) {
        return ServerFailure(errorMessage: response['errors'].toString());
      }
    } else if (response is String) {
      if (response.isNotEmpty) return ServerFailure(errorMessage: response);
    }
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errorMessage: 'unauthorized_error'.tr());
    } else if (statusCode == 404) {
      return ServerFailure(errorMessage: 'not_found_error'.tr());
    } else if (statusCode == 500) {
      return ServerFailure(errorMessage: 'server_error'.tr());
    } else {
      return ServerFailure(errorMessage: 'something_went_wrong'.tr());
    }
  }
}
