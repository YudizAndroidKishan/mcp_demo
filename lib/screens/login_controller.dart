import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Simulate a login service (replace with your actual API call)
  Future<bool> _loginService(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple hardcoded check for demonstration purposes
    if (username == 'testuser' && password == 'password123') {
      return true;
    } else {
      return false;
    }
  }

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _loginService(_username, _password);

    _isLoading = false;
    if (success) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid username or password';
      notifyListeners();
      return false;
    }
  }

  // Optional: Method to reset the state for testing purposes
  void resetState() {
    _username = '';
    _password = '';
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
