import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Bright, cheerful sky blue as our foundation
  static const Color primary = Color(0xFF4DABF7);       // Vibrant sky blue - like a clear summer day
  static const Color primaryVariant = Color(0xFF339AF0); // Slightly deeper sky blue
  static const Color secondary = Color(0xFF51CF66);     // Fresh spring green - represents growth
  static const Color secondaryVariant = Color(0xFF40C057); // Deeper spring green

  // Background colors - Clean, bright foundation
  static const Color background = Color(0xFFF8F9FA);    // Crisp, fresh white with slight warmth
  static const Color surface = Color(0xFFFFFFFF);       // Pure white for maximum clarity

  // Text colors - Friendly but readable
  static const Color onPrimary = Color(0xFFFFFFFF);     // White
  static const Color onSecondary = Color(0xFFFFFFFF);   // White
  static const Color onBackground = Color(0xFF495057);  // Warm gray, friendlier than pure black
  static const Color onSurface = Color(0xFF868E96);     // Medium warm gray for secondary text

  // Status colors - Optimistic and friendly
  static const Color error = Color(0xFFFFA8A8);         // Soft coral red - less harsh
  static const Color success = Color(0xFF69DB7C);       // Fresh mint green
  static const Color warning = Color(0xFFFFD43B);       // Cheerful yellow
  static const Color info = Color(0xFF74C0FC);          // Light sky blue
  static const Color onError = Color(0xFF495057);       // Dark gray for error text
  static const Color onSuccess = Color(0xFF495057);     // Dark gray for success text

  // Interactive states - Playful but clear
  static const Color disabled = Color(0xFFE9ECEF);      // Light gray with warmth
  static const Color focused = Color(0xFF74C0FC);       // Bright blue for focus
  static const Color hint = Color(0xFFADB5BD);          // Warm medium gray
  static const Color overlay = Color(0x66495057);       // Semi-transparent gray
  static const Color divider = Color(0xFFE9ECEF);       // Subtle warm gray divider

  // Transparency variants - Subtle interactions
  static const Color onSurfaceDisabled = Color(0x61495057);
  static const Color onPrimaryDisabled = Color(0x61FFFFFF);

  // Dark mode colors - Rich but not gloomy
  static const Color darkBackground = Color(0xFF2B3035); // Deep warm gray
  static const Color darkSurface = Color(0xFF343A40);   // Slightly lighter warm gray
  static const Color darkOnBackground = Color(0xFFF1F3F5); // Bright but not harsh
  static const Color darkOnSurface = Color(0xFFDEE2E6);   // Soft light gray
  static const Color darkHint = Color(0xFFADB5BD);        // Medium warm gray
  static const Color darkDisabled = Color(0x62F1F3F5);    // Semi-transparent light
}