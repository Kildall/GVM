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

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    final headers = await _getAuthHeaders();
    return _httpService.sendRequest('GET', endpoint, headers: headers, queryParameters: queryParams);
  }

  Future<Map<String, dynamic>> post(String endpoint, {dynamic body}) async {
    final headers = await _getAuthHeaders();
    return _httpService.sendRequest('POST', endpoint, headers: headers, body: body);
  }

  Future<Map<String, dynamic>> put(String endpoint, {dynamic body}) async {
    final headers = await _getAuthHeaders();
    return _httpService.sendRequest('PUT', endpoint, headers: headers, body: body);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final headers = await _getAuthHeaders();
    return _httpService.sendRequest('DELETE', endpoint, headers: headers);
  }
}