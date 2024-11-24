// •	Where to import:
// •	In forms or controllers where user input needs to be validated.
// •	In UI pages like login, sign-up, or profile forms.
//
// import 'package:your_app_name/core/utils/validators.dart';
//
// // Validate email in a login form
// final emailError = Validators.validateEmail(userEmail);
// if (emailError != null) {
// print(emailError); // Show error to the user
// }
//
// // Validate password in a sign-up form
// final passwordError = Validators.validatePassword(userPassword);
// if (passwordError != null) {
// print(passwordError);
// }



class Validators {
  /// Checks if the input is a valid email.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty.';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  /// Checks if the input is a valid password.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  /// Checks if the input matches a required length.
  static String? validateMinLength(String? input, int minLength) {
    if (input == null || input.length < minLength) {
      return 'Input must be at least $minLength characters long.';
    }
    return null;
  }
}