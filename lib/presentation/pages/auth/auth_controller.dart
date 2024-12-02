import 'package:flutter/material.dart';
import '../../../data/utils/firebase_auth_service.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuthService _authService;

  AuthController(this._authService);

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// Login method
  Future<bool> login(String email, String password) async {
    _startLoading();
    try {
      clearError(); // Reset error state before operation
      final user = await _authService.signIn(email, password);
      return user != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _stopLoading();
    }
  }

  /// Signup method with user details
  Future<bool> signUp(String name, String email, String password, String preferences) async {
    _startLoading();
    try {
      clearError(); // Reset error state before operation

      // Convert preferences to a map if it's a string
      Map<String, dynamic> preferencesMap = {'preferences': preferences};

      final user = await _authService.signUp(email, password, name, preferencesMap);
      return user != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _stopLoading();
    }
  }

  /// Logout method
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Reset the error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Set loading state to true
  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Set loading state to false
  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}