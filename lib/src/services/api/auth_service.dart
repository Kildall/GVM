import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isAuthenticated = false;

  AuthService() {
    _checkInitialAuthStatus();
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> _checkInitialAuthStatus() async {
    _isAuthenticated = await _hasValidToken();
    notifyListeners();
  }

  Future<bool> _hasValidToken() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return false;

    final expirationString = await _secureStorage.read(key: 'token_expiration');
    if (expirationString == null) return false;

    final expiration = DateTime.parse(expirationString);
    return DateTime.now().isBefore(expiration);
  }

  Future<void> login(String token, String expiration) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'token_expiration', value: expiration);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'token_expiration');
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<String?> getToken() async {
    if (await _hasValidToken()) {
      return _secureStorage.read(key: 'jwt_token');
    }
    return null;
  }
}