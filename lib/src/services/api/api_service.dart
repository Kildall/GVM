import 'dart:developer' as developer;

import 'package:gvm_flutter/src/models/response/generic_responses.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/http_service.dart';

class APIService {
  final HTTPService _httpService;
  final Future<String?> Function()? getToken;

  APIService(String baseUrl, Future<String?> Function() this.getToken)
      : _httpService = HTTPService(baseUrl);

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken?.call();
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  void _handleErrors(List<APIError> errors) {
    if (errors.isEmpty) return;

    final error = errors.first;
    final errorCode = ErrorCode.values.firstWhere(
        (e) => e.index == error.code - 1000,
        orElse: () => ErrorCode.SERVER_ERROR);

    switch (errorCode) {
      case ErrorCode.AUTH_ERROR:
      case ErrorCode.ACCESS_DENIED:
      case ErrorCode.INVALID_TOKEN:
      case ErrorCode.TOKEN_EXPIRED:
      case ErrorCode.MISSING_AUTH:
      case ErrorCode.AUTHENTICATED:
      case ErrorCode.USER_NOT_FOUND:
        throw AuthException(errorCode, error.message);

      case ErrorCode.USER_ERROR:
      case ErrorCode.INCORRECT_PASSWORD:
      case ErrorCode.USER_ALREADY_EXISTS:
      case ErrorCode.USER_NOT_ENABLED:
        throw UserException(errorCode, error.message);

      case ErrorCode.RESOURCE_ERROR:
      case ErrorCode.RESOURCE_NOT_FOUND:
      case ErrorCode.RESOURCE_ALREADY_EXISTS:
      case ErrorCode.RESOURCE_UPDATE_FAILED:
        throw ResourceException(errorCode, error.message);

      case ErrorCode.VALIDATION_ERROR:
      case ErrorCode.INVALID_PARAMS:
      case ErrorCode.INSUFFICIENT_INVENTORY:
        throw ValidationException(errorCode, error.message);

      case ErrorCode.SERVER_ERROR:
      case ErrorCode.DATABASE_ERROR:
        throw ServerException(errorCode, error.message);

      default:
        // Log unexpected error code to console
        developer.log(
          'Unexpected error code encountered',
          error: 'Error code: ${error.code}, Message: ${error.message}',
          name: 'APIService',
        );
        throw ServerException(
            ErrorCode.SERVER_ERROR, 'An unexpected error occurred');
    }
  }

  Future<APIResponse<T>> _handleResponse<T>(
      Future<Map<String, dynamic>> Function() request,
      T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await request();
      final apiResponse = APIResponse.fromJson(response, fromJson);

      if (!apiResponse.success) {
        _handleErrors(apiResponse.errors);
      }

      return apiResponse;
    } catch (e) {
      if (e is APIException) {
        developer.log(
          'APIException occurred',
          error: e.toString(),
          name: 'APIService',
        );
        rethrow;
      }
      // Log unexpected error to console
      developer.log(
        'Unexpected error occurred',
        error: e.toString(),
        name: 'APIService',
      );
      throw ServerException(ErrorCode.SERVER_ERROR, e.toString());
    }
  }

  Future<APIResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleResponse(
        () => _httpService.sendRequest('GET', endpoint,
            headers: headers, queryParameters: queryParams),
        fromJson);
  }

  Future<APIResponse<T>> post<T>(
    String endpoint, {
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleResponse(
        () => _httpService.sendRequest('POST', endpoint,
            headers: headers, body: body),
        fromJson);
  }

  Future<APIResponse<T>> put<T>(
    String endpoint, {
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleResponse(
        () => _httpService.sendRequest('PUT', endpoint,
            headers: headers, body: body),
        fromJson);
  }

  Future<APIResponse<T>> delete<T>(
    String endpoint, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleResponse(
        () => _httpService.sendRequest('DELETE', endpoint, headers: headers),
        fromJson);
  }
}
