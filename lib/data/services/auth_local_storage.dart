import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class AuthLocalStorage {
  AuthLocalStorage._();

  static final AuthLocalStorage instance = AuthLocalStorage._();

  final GetStorage _storage = GetStorage();

  static const String _accessTokenKey = 'accessToken';
  static const String _userDataKey = 'userData';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _rememberMeKey = 'rememberMe';
  static const String _savedEmailKey = 'savedEmail';
  static const String _savedPasswordKey = 'savedPassword';

  Future<void> saveLoginData({
    required String accessToken,
    required dynamic userData,
    required bool rememberMe,
    String? email,
    String? password,
  }) async {
    await _storage.write(_accessTokenKey, accessToken);

    await _storage.write(_userDataKey, jsonEncode(userData));

    await _storage.write(_isLoggedInKey, true);

    await _storage.write(_rememberMeKey, rememberMe);

    if (rememberMe) {
      await _storage.write(_savedEmailKey, email);

      await _storage.write(_savedPasswordKey, password);
    } else {
      await _storage.remove(_savedEmailKey);
      await _storage.remove(_savedPasswordKey);
    }

    // Make sure data is written.
    await _storage.save();
  }

  String? getAccessToken() {
    return _storage.read<String>(_accessTokenKey);
  }

  Map<String, dynamic>? getUserData() {
    final value = _storage.read<String>(_userDataKey);

    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final data = jsonDecode(value);

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    } catch (error) {
      print('USER DATA ERROR: $error');
    }

    return null;
  }

  bool getRememberMe() {
    return _storage.read<bool>(_rememberMeKey) ?? false;
  }

  String? getSavedEmail() {
    return _storage.read<String>(_savedEmailKey);
  }

  String? getSavedPassword() {
    return _storage.read<String>(_savedPasswordKey);
  }

  bool isLoggedIn() {
    return _storage.read<bool>(_isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_userDataKey);
    await _storage.remove(_isLoggedInKey);

    // Keep remembered credentials if you want
    // Remember Me to continue working.
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
