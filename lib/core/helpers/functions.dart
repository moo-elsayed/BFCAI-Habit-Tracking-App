import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../shared_data/models/api_response/api_response.dart';
import 'app_logger.dart';
import 'failures.dart';
import 'network_response.dart';

bool isArabic(BuildContext context) => context.locale.languageCode == 'ar';

String getErrorMessage(result) =>
    ((result.exception as dynamic).message ?? result.exception.toString())
        .replaceAll('Exception: ', '');

NetworkFailure<T> handleError<T>(Object e, String functionName) {
  AppLogger.error("error occurred in $functionName", error: e);
  if (e is DioException) {
    return NetworkFailure(
      Exception(ServerFailure.fromDioException(e).errorMessage),
    );
  }
  return NetworkFailure(Exception(e.toString()));
}

T returnResponse<T>(ApiResponse<T> apiResponse, Response<dynamic> response) {
  if (!apiResponse.isSuccess) {
    throwDioException(response, apiResponse);
  }
  return apiResponse.data as T;
}

void throwDioException(Response<dynamic> response, ApiResponse apiResponse) =>
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: apiResponse.message,
      type: DioExceptionType.badResponse,
    );

int parseDayStringToInt(String day) {
  switch (day.toLowerCase()) {
    case 'saturday':
      return 1;
    case 'sunday':
      return 2;
    case 'monday':
      return 3;
    case 'tuesday':
      return 4;
    case 'wednesday':
      return 5;
    case 'thursday':
      return 6;
    case 'friday':
      return 7;
    default:
      return 1;
  }
}
