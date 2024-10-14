import 'dart:convert';
import 'package:gvm_flutter/src/services/api/auth_service.dart';
import 'package:http/http.dart' as http;

class APIService {
  final String baseUrl;
  final http.Client _httpClient = http.Client();
  final AuthService _authService;

  APIService(this.baseUrl, this._authService);

  Future<bool> login(String email, String password, bool remember) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/api/auth/login'),
      body: jsonEncode({'email': email, 'password': password, 'remember': remember}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status']['success']) {
        await _authService.login(
          responseData['data']['token'],
          responseData['data']['expires'],
        );
        return true;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    return _sendRequest('GET', endpoint);
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    return _sendRequest('POST', endpoint, data: data);
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    return _sendRequest('PUT', endpoint, data: data);
  }

  Future<void> delete(String endpoint) async {
    await _sendRequest('DELETE', endpoint);
  }

    Future<Map<String, dynamic>> _sendRequest(String method, String endpoint, {dynamic data}) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw UnauthorizedAccessException('No valid token. Please login.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response;
    final uri = Uri.parse('$baseUrl$endpoint');

    switch (method) {
      case 'GET':
        response = await _httpClient.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _httpClient.post(uri, headers: headers, body: jsonEncode(data));
        break;
      case 'PUT':
        response = await _httpClient.put(uri, headers: headers, body: jsonEncode(data));
        break;
      case 'DELETE':
        response = await _httpClient.delete(uri, headers: headers);
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    if (response.statusCode == 401) {
      await _authService.logout();
      throw UnauthorizedAccessException('Session is no longer valid. Please login again.');
    }

    final responseData = jsonDecode(response.body);
    if (!responseData['status']['success']) {
      throw Exception('API request failed: ${responseData['status']['errors'].join(', ')}');
    }

    return responseData['data'];
 }
}

class UnauthorizedAccessException implements Exception {
  final String message;
  UnauthorizedAccessException(this.message);
}