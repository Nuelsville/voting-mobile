import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    notifyListeners();
  }

  Future<void> signIn(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
