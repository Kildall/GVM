import 'dart:convert';

class APIResponse<T> {
  final bool success;
  final List<APIError> errors;
  final T? data;

  APIResponse({required this.success, required this.errors, this.data});

  factory APIResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final response = APIResponse(
      success: json['status']['success'],
      errors: (json['status']['errors'] as List?)
              ?.map((e) => APIError.fromJson(e))
              .toList() ??
          [],
      data: json['data'] != null ? fromJson(json['data']) : null,
    );

    return response;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'success': success,
      'errors': errors.map((e) => e.toJson()).toList(),
    };

    if (data != null) {
      json['data'] = jsonEncode(data);
    }

    return json;
  }
}

class APIError {
  final int code;
  final String message;

  APIError({required this.code, required this.message});

  factory APIError.fromJson(Map<String, dynamic> json) {
    return APIError(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class GenericMessageResponse {
  final String message;

  GenericMessageResponse({required this.message});

  factory GenericMessageResponse.fromJson(Map<String, dynamic> json) {
    return GenericMessageResponse(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
