import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6200EE); // Purple
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6); // Teal
  static const Color secondaryVariant = Color(0xFF018786);

  // Background colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF5F5F5); // Light gray

  // Text colors
  static const Color onPrimary = Color(0xFFFFFFFF); // White
  static const Color onSecondary = Color(0xFF000000); // Black
  static const Color onBackground = Color(0xFF000000); // Black
  static const Color onSurface = Color(0xFF000000); // Black

  // Error colors
  static const Color error = Color(0xFFB00020); // Red
  static const Color onError = Color(0xFFFFFFFF);

  // Additional states
  static const Color disabled = Color(0xFFBDBDBD); // Light gray for disabled elements
  static const Color focused = Color(0xFF6200EE); // Same as primary
  static const Color hint = Color(0xFF757575); // Gray for hint text or icons
  static const Color overlay = Color(0x99000000); // Semi-transparent black for overlays
  static const Color divider = Color(0xFFE0E0E0); // Divider color

  // Transparency variants
  static const Color onSurfaceDisabled = Color(0x61000000); // 38% opacity black
  static const Color onPrimaryDisabled = Color(0x61FFFFFF); // 38% opacity white

  // Dark mode colors (optional)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFE0E0E0);

  // Semantic additions for dark mode
  static const Color darkHint = Color(0x80FFFFFF); // Hint text in dark mode
  static const Color darkDisabled = Color(0x62FFFFFF); // Disabled elements in dark mode
}
