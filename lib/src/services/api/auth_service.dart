import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String baseUrl;
  bool _isAuthenticated = false;
  String? _token;
  DateTime? _tokenExpiration;
  bool _isLoading = false;

  AuthService(this.baseUrl) {
    _checkInitialAuthStatus();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> _checkInitialAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    _token = await _secureStorage.read(key: 'jwt_token');
    final expirationString = await _secureStorage.read(key: 'token_expiration');
    if (expirationString != null) {
      _tokenExpiration = DateTime.parse(expirationString);
    }
    
    if (await _hasValidToken()) {
      // If we have a locally valid token, verify it with the server
      _isAuthenticated = await validateToken();
    } else {
      _isAuthenticated = false;
    }
    
    if (!_isAuthenticated) {
      // If the token is invalid or expired, clear the stored data
      await _clearAuthData();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> _hasValidToken() {
    if (_token == null || _tokenExpiration == null) return Future.value(false);
    return Future.value(DateTime.now().isBefore(_tokenExpiration!));
  }

  Future<void> _saveToken(String token, DateTime expiration) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'token_expiration', value: expiration.toIso8601String());
    _token = token;
    _tokenExpiration = expiration;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<String?> getToken() async {
    if (await _hasValidToken()) {
      return _token;
    }
    return null;
  }

  Future<Map<String, dynamic>> signup(String email, String password, String name) async {
    if (_isAuthenticated) {
      throw Exception('You are already logged in');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<bool> login(String email, String password, bool remember) async {
    if (_isAuthenticated) {
      throw Exception('You are already logged in');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'remember': remember,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status']['success']) {
        await _saveToken(
          responseData['data']['token'],
          DateTime.parse(responseData['data']['expires']),
        );
        return true;
      }
    }
    return false;
  }

  Future<bool> logout() async {
    if (!_isAuthenticated) {
      return true;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      await _clearAuthData();
      return true;
    }
    return false;
  }

  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'token_expiration');
    _token = null;
    _tokenExpiration = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> verifyAccount(String signature) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/verify/$signature'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify account');
    }
  }

  Future<bool> validateToken() async {
    if (_token == null) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/validate-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['valid'] ?? false;
      }
    } catch (e) {
      // If there's a network error, we assume the token is invalid
      print('Error validating token: $e');
    }

    return false;
  }

}