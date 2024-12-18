import 'package:flutter/material.dart';

class AppColors {
  // Gift-themed primary colors
  static const Color primary = Color(0xFFFF6B9E); // Soft, happy pink
  static const Color primaryVariant = Color(0xFFFF4081); // Slightly deeper pink
  static const Color secondary = Color(0xFF4ECDC4); // Fresh, modern teal
  static const Color secondaryVariant = Color(0xFF45B7D1); // Lighter teal

  // Background colors
  static const Color background = Color(0xFFFFF5F5); // Soft, warm white with a hint of pink
  static const Color surface = Color(0xFFFFF0F5); // Light pink surface

  // Text colors
  static const Color onPrimary = Color(0xFFFFFFFF); // White
  static const Color onSecondary = Color(0xFFFFFFFF); // White
  static const Color onBackground = Color(0xFF333333); // Soft black
  static const Color onSurface = Color(0xFF444444); // Slightly lighter black

  // Error colors
  static const Color error = Color(0xFFF44336); // Vibrant red
  static const Color onError = Color(0xFFFFFFFF);

  // Additional states
  static const Color disabled = Color(0xFFE0E0E0); // Light gray
  static const Color focused = Color(0xFFFF6B9E); // Same as primary
  static const Color hint = Color(0xFF9E9E9E); // Soft gray
  static const Color overlay = Color(0x66000000); // Semi-transparent black
  static const Color divider = Color(0xFFE0E0E0); // Light divider

  // Transparency variants
  static const Color onSurfaceDisabled = Color(0x61000000);
  static const Color onPrimaryDisabled = Color(0x61FFFFFF);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkHint = Color(0x80FFFFFF);
  static const Color darkDisabled = Color(0x62FFFFFF);
}