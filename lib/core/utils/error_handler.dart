// Where to import:
// •	In repositories and use cases, where you handle exceptions from API calls, local data sources, or business logic.
// •	In controllers, where user-facing error messages are shown.
// //
// import 'package:your_app_name/core/utils/error_handler.dart';
//
// try {
// // Some logic
// } catch (e, stackTrace) {
// ErrorHandler.handleError(e, stackTrace);
// final errorMessage = ErrorHandler.getErrorMessage(e);
// print(errorMessage); // Show this to the user or log it.
// }

import 'dart:developer';






class ErrorHandler {
  /// Handles exceptions globally, optionally logs the error.
  static void handleError(Exception e, [StackTrace? stackTrace]) {
    log('Error: ${e.toString()}');
    if (stackTrace != null) {
      log('StackTrace: $stackTrace');
    }
  }

  /// Converts an exception into a user-friendly error message.
  static String getErrorMessage(Exception e) {
    if (e is NetworkException) {
      return 'Unable to connect to the network. Please try again later.';
    } else if (e is ValidationException) {
      return 'Validation error: ${e.message}';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}