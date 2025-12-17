import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int? statusCode;
  final dynamic meta;
  final bool? succeeded;
  final String? message;
  final dynamic errors;
  final T? data;

  ApiResponse({
    this.statusCode,
    this.meta,
    this.succeeded,
    this.message,
    this.errors,
    this.data,
  });

  bool get isSuccess {
    if (succeeded != null) {
      return succeeded!;
    }
    return statusCode != null && statusCode! >= 200 && statusCode! < 300;
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
