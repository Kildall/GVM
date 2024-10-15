import 'dart:convert';
import 'package:http/http.dart' as http;

class HTTPService {
  final String baseUrl;
  final http.Client _httpClient = http.Client();

  HTTPService(this.baseUrl);

  Future<Map<String, dynamic>> sendRequest(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParameters);
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    http.Response response;

    switch (method) {
      case 'GET':
        response = await _httpClient.get(uri, headers: requestHeaders);
        break;
      case 'POST':
        response = await _httpClient.post(uri, headers: requestHeaders, body: jsonEncode(body));
        break;
      case 'PUT':
        response = await _httpClient.put(uri, headers: requestHeaders, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await _httpClient.delete(uri, headers: requestHeaders);
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    final responseData = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      throw HTTPException(response.statusCode, responseData['message'] ?? 'Request failed');
    }
  }
}

class HTTPException implements Exception {
  final int statusCode;
  final String message;

  HTTPException(this.statusCode, this.message);

  @override
  String toString() => 'HTTPException: $statusCode - $message';
}