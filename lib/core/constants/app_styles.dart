import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Headline styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  // Body text styles
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyText3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceDisabled, // Uses semi-transparent variant
  );

  // Caption style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.hint,
  );

  // Button text style
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  // Input text styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
  );

  // Error text style
  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  // AppBar Text Style
  static const TextStyle appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  // App theme (Define overall theme styles)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        titleTextStyle: appBarTextStyle,
        elevation: 4,
      ),
      textTheme: TextTheme(
        displayLarge: headline1,
        displayMedium: headline2,
        displaySmall: headline3,
        bodyLarge: bodyText1,
        bodyMedium: bodyText2,
        bodySmall: caption,
        labelLarge: button,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: inputLabel,
        hintStyle: caption, // Reusing caption style for hints
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.focused, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.4)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        titleTextStyle: appBarTextStyle.copyWith(color: AppColors.onPrimary),
        elevation: 4,
      ),
      textTheme: TextTheme(
        displayLarge: headline1.copyWith(color: AppColors.darkOnBackground),
        displayMedium: headline2.copyWith(color: AppColors.darkOnBackground),
        displaySmall: headline3.copyWith(color: AppColors.darkOnBackground),
        bodyLarge: bodyText1.copyWith(color: AppColors.darkOnSurface),
        bodyMedium: bodyText2.copyWith(color: AppColors.darkOnSurface),
        bodySmall: caption.copyWith(color: AppColors.darkHint),
        labelLarge: button.copyWith(color: AppColors.darkOnBackground),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: inputLabel.copyWith(color: AppColors.darkOnSurface),
        hintStyle: caption.copyWith(color: AppColors.darkHint),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkOnSurface.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.focused, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkOnSurface.withOpacity(0.4)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
