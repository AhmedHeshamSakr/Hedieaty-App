// lib/presentation/controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences preferences;
  late ThemeMode _themeMode;

  ThemeController(this.preferences) {
    // Load saved theme mode or default to system
    _themeMode = _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  // Load theme mode from persistent storage
  ThemeMode _loadThemeMode() {
    final savedMode = preferences.getString(_themeKey);
    return savedMode == null
        ? ThemeMode.system
        : ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
      orElse: () => ThemeMode.system,
    );
  }

  // Save and update theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await preferences.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  // Toggle between light and dark mode
  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
