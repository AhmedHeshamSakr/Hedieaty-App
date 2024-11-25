import 'package:flutter/material.dart';
import '../../../data/utils/firebase_auth_service.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuthService _authService;

  AuthController(this._authService);

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// Signup method
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signUp(email, password);
      _setLoading(false);
      return true; // Signup successful
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false; // Signup failed
    }
  }

  /// Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email, password);
      _setLoading(false);
      return true; // Login successful
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false; // Login failed
    }
  }

  /// Reset state
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Private helper for loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
