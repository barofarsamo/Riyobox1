import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String _backendUrl = 'http://localhost:5000';
  bool _isAuthenticated = false;
  bool _isOnboardingComplete = false;
  String? _token;
  String? _role;

  bool get isAuthenticated => _isAuthenticated;
  bool get isOnboardingComplete => _isOnboardingComplete;
  String? get token => _token;
  String? get role => _role;

  AuthProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
    _token = prefs.getString('token');
    _role = prefs.getString('role');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _role = data['role'];
        _isAuthenticated = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('token', _token!);
        await prefs.setString('role', _role!);
        notifyListeners();
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) { rethrow; }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _role = data['role'];
        _isAuthenticated = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('token', _token!);
        await prefs.setString('role', _role!);
        notifyListeners();
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) { rethrow; }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('token');
    await prefs.remove('role');
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    notifyListeners();
  }

  Future<bool> checkSession() async {
    // Simulate API token validation
    await Future.delayed(const Duration(milliseconds: 500));
    if (_token == null) {
      _isAuthenticated = false;
      return false;
    }
    // Assume token is valid if present for this mock
    return true;
  }
}
