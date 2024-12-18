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
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    Map<String, dynamic>? preferences,
  }) async {
    _startLoading();
    try {
      clearError(); // Reset error state before operation

      // Prepare preferences map
      final userPreferences = preferences ?? {};

      // If a single preferences string is passed, convert it to a map
      if (preferences == null && preferences is String && preferences!.isNotEmpty) {
        try {
          userPreferences['custom_preference'] = preferences;
        } catch (e) {
          _setError('Invalid preferences format');
          return false;
        }
      }

      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        preferences: userPreferences,
      );
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
    _startLoading();
    try {
      clearError();
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  /// Password reset method
  Future<bool> resetPassword(String email) async {
    _startLoading();
    try {
      clearError();
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _stopLoading();
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