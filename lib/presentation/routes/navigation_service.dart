import 'package:flutter/material.dart';

class NavigationService {
  // Singleton instance for centralized navigation
  static final NavigationService _instance = NavigationService._();
  NavigationService._();
  factory NavigationService() => _instance;

  // GlobalKey to access Navigator's state
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a specific route with optional arguments
  Future<void> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  /// Replace the current route with a new one
  Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navigate to a route and clear all previous routes
  Future<dynamic> navigateAndClear(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route
  void goBack([dynamic result]) {
    navigatorKey.currentState!.pop(result);
  }

  /// Check if there are routes to pop
  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  /// Show a dialog using the current navigator context
  Future<dynamic> showDialogBox(Widget dialog) {
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) => dialog,
    );
  }

  /// Show a bottom sheet
  Future<dynamic> showBottomSheet(Widget sheet) {
    return showModalBottomSheet(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) => sheet,
    );
  }
}
