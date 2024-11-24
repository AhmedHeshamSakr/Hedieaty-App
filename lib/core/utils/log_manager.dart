// •	Where to import:
// •	In any file where you want to log debug, info, or error messages.
// •	Ideal for logging in services, data sources, or controllers to track issues.
//
// Example:
// import 'package:your_app_name/core/utils/log_manager.dart';
//
// LogManager.debug('Fetching data from API...');
// LogManager.info('User successfully logged in.');
// LogManager.error('Failed to load data.', exception: someException);




import 'dart:developer';

class LogManager {
  /// Logs debug messages in development mode.
  static void debug(String message) {
    const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
    if (isDebug) {
      log('[DEBUG]: $message');
    }
  }

  /// Logs error messages.
  static void error(String message, {Exception? exception, StackTrace? stackTrace}) {
    log('[ERROR]: $message');
    if (exception != null) {
      log('Exception: ${exception.toString()}');
    }
    if (stackTrace != null) {
      log('StackTrace: $stackTrace');
    }
  }

  /// Logs info messages.
  static void info(String message) {
    log('[INFO]: $message');
  }
}