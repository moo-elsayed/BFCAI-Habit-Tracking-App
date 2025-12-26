import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  const Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case .connectionTimeout:
        return const ServerFailure(errorMessage: 'connection_timeout');

      case .sendTimeout:
        return const ServerFailure(errorMessage: 'send_timeout');

      case .receiveTimeout:
        return const ServerFailure(errorMessage: 'receive_timeout');

      case .badCertificate:
        return const ServerFailure(errorMessage: 'bad_certificate');

      case .badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );

      case .cancel:
        return const ServerFailure(errorMessage: 'request_canceled');

      case .connectionError:
        return const ServerFailure(errorMessage: 'no_internet_connection');

      case .unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return const ServerFailure(errorMessage: 'no_internet_connection');
        }
        return const ServerFailure(errorMessage: 'unexpected_error');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (response == null) {
      return const ServerFailure(errorMessage: 'unknown_error');
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
      return const ServerFailure(errorMessage: 'unauthorized_error');
    } else if (statusCode == 404) {
      return const ServerFailure(errorMessage: 'not_found_error');
    } else if (statusCode == 500) {
      return const ServerFailure(errorMessage: 'server_error');
    } else {
      return const ServerFailure(errorMessage: 'something_went_wrong');
    }
  }
}
