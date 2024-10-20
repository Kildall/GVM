import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gvm_flutter/src/models/auth/user.dart';
import 'package:gvm_flutter/src/models/response/auth_responses.dart';
import 'package:gvm_flutter/src/models/response/generic_responses.dart';
import 'package:gvm_flutter/src/services/api/api_service.dart';
import 'package:gvm_flutter/src/services/auth/auth_exceptions.dart';

class AuthManager {
  final _authStateToken = 'APP_TOKEN';
  final _tokenExpirationKey = 'TOKEN_EXPIRATION';
  final _userDataKey = 'USER_DATA';

  final FlutterSecureStorage _secureStorage;
  final StreamController<bool>? _authStateController;
  late final APIService _apiService;

  AuthUser? _currentUser;

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
      _currentUser = AuthUser.fromJson(userData);
    } else {
      await _clearAuthData();
    }
  }

  Future<APIResponse<VerifyTokenResponse>> validateToken(String token) async {
    final response = await _apiService.post<VerifyTokenResponse>(
        '/api/auth/validate-token',
        body: {'token': token},
        fromJson: VerifyTokenResponse.fromJson);
    return response;
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
    final response = await _apiService.post<LoginResponse>('/api/auth/login',
        body: {
          'email': email,
          'password': password,
          'remember': remember,
        },
        fromJson: LoginResponse.fromJson);

    if (response.data != null) {
      final token = response.data!.token;
      final expirationDate = response.data!.expires;
      await setToken(token, expirationDate);
      await fetchUserData();
      _authStateController!.sink.add(true);
    }
  }

  Future<void> fetchUserData() async {
    try {
      final response = await _apiService.get<AuthUser>('/api/auth/user',
          fromJson: AuthUser.fromJson);

      if (response.data != null) {
        final userData = response.data!;
        _currentUser = userData;
        await _secureStorage.write(
            key: _userDataKey, value: json.encode(userData));
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> logout() async {
    await _apiService.post<GenericMessageResponse>('/api/auth/logout',
        fromJson: GenericMessageResponse.fromJson);
    await _clearAuthData();
  }

  Future<bool> signup(String email, String password, String name) async {
    await _apiService.post<GenericMessageResponse>('/api/auth/signup',
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
        fromJson: GenericMessageResponse.fromJson);

    return true;
  }

  Future<bool> verifyAccount(String signature) async {
    await _apiService.get<GenericMessageResponse>('/api/auth/verify/$signature',
        fromJson: GenericMessageResponse.fromJson);

    return true;
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

    final validationResult = await validateToken(token);
    if (validationResult.data != null && validationResult.data!.valid) {
      return true;
    }
    await _clearAuthData();
    return false;
  }

  AuthUser? get currentUser => _currentUser;

  APIService get apiService => _apiService;
}
