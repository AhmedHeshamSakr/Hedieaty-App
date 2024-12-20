import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    letterSpacing: -0.25,
    height: 1.35,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    letterSpacing: 0,
    height: 1.4,
  );

  // Body text styles with improved readability
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    height: 1.45,
    letterSpacing: 0.25,
  );

  static const TextStyle bodyText3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceDisabled,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // Enhanced button styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.5,
    height: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.25,
    height: 1.25,
  );

  // Navigation bar text style
  static const TextStyle bottomNavLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onPrimary,
    letterSpacing: 0.4,
    height: 1.2,
  );

  // Input and form styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    letterSpacing: 0.15,
    height: 1.5,
  );

  // Refined app bar style
  static const TextStyle appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),

      // Enhanced AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        titleTextStyle: appBarTextStyle,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),

      // Bottom Navigation Bar theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.3),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: buttonLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.primaryVariant;
              }
              if (states.contains(MaterialState.hovered)) {
                return AppColors.primary.withOpacity(0.8);
              }
              return null;
            },
          ),
        ),
      ),

      // Refined outlined button theme with better hover states
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 2),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: buttonLarge.copyWith(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.primary.withOpacity(0.15);
              }
              if (states.contains(MaterialState.hovered)) {
                return AppColors.primary.withOpacity(0.08);
              }
              return null;
            },
          ),
        ),
      ),

      // Enhanced text button theme with better interaction states
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: buttonMedium.copyWith(color: AppColors.primary),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary.withOpacity(0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withOpacity(0.06);
              }
              return null;
            },
          ),
        ),
      ),

      // Enhanced Bottom Navigation Bar theme with brighter selection
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.black87,  // Bright white for selected items
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedLabelStyle: bottomNavLabel.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: bottomNavLabel.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          size: 28,
          color: Colors.white,  // Bright white for selected icons
          opacity: 1.0,
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
          color: Colors.black87,
          opacity: 0.8,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: inputLabel,
        hintStyle: bodyText2.copyWith(color: AppColors.hint),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),

      textTheme: TextTheme(
        displayLarge: headline1,
        displayMedium: headline2,
        displaySmall: headline3,
        bodyLarge: bodyText1,
        bodyMedium: bodyText2,
        bodySmall: bodyText3,
        labelLarge: buttonLarge,
        labelMedium: buttonMedium,
      ),
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
      ),

      // Dark mode AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        titleTextStyle: appBarTextStyle,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),

      // Dark mode Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,  // Using primary color for selection
        unselectedItemColor: AppColors.darkOnSurface.withOpacity(0.7),
        selectedLabelStyle: bottomNavLabel.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: bottomNavLabel.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          size: 28,
          color: AppColors.primary,  // Primary color for selected icons
          opacity: 1.0,
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
          opacity: 0.8,
        ),
      ),
      // Dark mode text theme
      textTheme: TextTheme(
        displayLarge: headline1.copyWith(color: AppColors.darkOnBackground),
        displayMedium: headline2.copyWith(color: AppColors.darkOnBackground),
        displaySmall: headline3.copyWith(color: AppColors.darkOnBackground),
        bodyLarge: bodyText1.copyWith(color: AppColors.darkOnSurface),
        bodyMedium: bodyText2.copyWith(color: AppColors.darkOnSurface),
        bodySmall: bodyText3.copyWith(color: AppColors.darkOnSurface),
        labelLarge: buttonLarge,
        labelMedium: buttonMedium,
      ),

      // Dark mode input decoration
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: inputLabel.copyWith(color: AppColors.darkOnSurface),
        hintStyle: bodyText2.copyWith(color: AppColors.darkHint),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkOnSurface.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkOnSurface.withOpacity(0.2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}