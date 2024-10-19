import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gvm_flutter/src/models/response/dashboard/natives/user.dart';
import 'package:gvm_flutter/src/services/api/api_service.dart';
import 'package:gvm_flutter/src/services/auth/auth_exceptions.dart';

class AuthManager {
  final _authStateToken = 'APP_TOKEN';
  final _tokenExpirationKey = 'TOKEN_EXPIRATION';
  final _userDataKey = 'USER_DATA';

  final FlutterSecureStorage _secureStorage;
  final StreamController<bool>? _authStateController;
  late final APIService _apiService;

  User? _currentUser;

  AuthManager._(
    this._secureStorage,
    this._authStateController,
  );

  static AuthManager? _authStateInstance;

  static Future<void> initializeAuth(String baseUrl) async {
    if (_authStateInstance != null) return;

    final secureStorage = FlutterSecureStorage();

    _authStateInstance = AuthManager._(
      secureStorage,
      StreamController<bool>.broadcast(),
    );

    debugPrint('Started auth manager instance 👍');

    _authStateInstance!._apiService = APIService(
      baseUrl,
      () => _authStateInstance!.token,
    );

    debugPrint('Added api service instance 👍');

    // Read and validate existing token
    await _authStateInstance!._initializeToken();
    // Load user data
    await _authStateInstance!._loadUserData();
  }

  Future<void> _initializeToken() async {
    final token = await _secureStorage.read(key: _authStateToken);
    final expirationString =
        await _secureStorage.read(key: _tokenExpirationKey);
    if (token != null && expirationString != null) {
      final expiration = DateTime.parse(expirationString);
      if (DateTime.now().isAfter(expiration)) {
        await _clearAuthData();
      }
    } else {
      // If we reach here, either there's no token, it's expired, or validation failed
      await _clearAuthData();
    }

    Future.delayed(const Duration(milliseconds: 100), () async {
      final isAuthenticated = await this.isAuthenticated;
      _authStateInstance!._authStateController!.sink.add(isAuthenticated);
    });
  }

  Future<void> _loadUserData() async {
    final userDataString = await _secureStorage.read(key: _userDataKey);
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      _currentUser = User.fromJson(userData);
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _apiService
          .post('/api/auth/validate-token', body: {'token': token});
      return response['data']['valid'];
    } catch (e) {
      return false;
    }
  }

  /// Provides possibility to listen to Auth States.
  ///
  /// This is `Stream<bool>` type where `bool` is auth state.
  ///
  /// true = authenticated.
  ///
  /// false = unauthenticated.
  Stream<bool> get authStateAsStream {
    assert(
      _authStateController != null,
      throw UnInitializedState(
        'You are trying to listen to authStateStream but it is null.',
      ),
    );

    return _authStateController!.stream;
  }

  static AuthManager get instance {
    assert(
        _authStateInstance != null,
        throw UnInitializedState(
            'You are trying to get instance of the AuthSate but it is null.'));
    return _authStateInstance!;
  }

  Future<void> setToken(String token, DateTime expirationDate) async {
    assert(
      _authStateController != null,
      throw UnInitializedState(),
    );
    await _secureStorage.write(key: _authStateToken, value: token);
    await _secureStorage.write(
        key: _tokenExpirationKey, value: expirationDate.toIso8601String());
  }

  Future<void> login(String email, String password, bool remember) async {
    final response = await _apiService.post('/api/auth/login', body: {
      'email': email,
      'password': password,
      'remember': remember,
    });

    if (response['status']['success']) {
      final token = response['data']['token'];
      final expirationDate = DateTime.parse(response['data']['expires']);
      await setToken(token, expirationDate);
      await fetchUserData();

      _authStateController!.sink.add(true);
      // After successful login, fetch user data
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> fetchUserData() async {
    final response = await _apiService.get('/api/auth/user');
    if (response['status']['success']) {
      final userData = response['data']['user'];
      _currentUser = User.fromJson(userData);
      await _secureStorage.write(
          key: _userDataKey, value: json.encode(userData));
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> logout() async {
    await _apiService.post('/api/auth/logout');
    await _clearAuthData();
  }

  Future<bool> signup(String email, String password, String name) async {
    final response = await _apiService.post('/api/auth/signup', body: {
      'email': email,
      'password': password,
      'name': name,
    });

    if (!response['status']['success']) {
      return false;
    }

    return true;
  }

  Future<void> verifyAccount(String signature) async {
    final response = await _apiService.get('/api/auth/verify/$signature');

    if (!response['status']['success']) {
      throw Exception('Account verification failed');
    }
  }

  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: _authStateToken);
    await _secureStorage.delete(key: _tokenExpirationKey);
    await _secureStorage.delete(key: _userDataKey);
    _currentUser = null;
    _authStateController!.sink.add(false);
  }

  Future<String?> get token async {
    final token = await _secureStorage.read(key: _authStateToken);
    final expirationString =
        await _secureStorage.read(key: _tokenExpirationKey);

    if (token != null && expirationString != null) {
      final expiration = DateTime.parse(expirationString);
      if (DateTime.now().isBefore(expiration)) {
        return token;
      } else {
        await _clearAuthData();
      }
    }
    return null;
  }

  Future<bool> get isAuthenticated async {
    final token = await this.token;
    if (token == null) {
      return false;
    }

    final isValid = await validateToken(token);
    if (!isValid) {
      await _clearAuthData();
    }
    return isValid;
  }

  User? get currentUser => _currentUser;

  APIService get apiService => _apiService;
}
