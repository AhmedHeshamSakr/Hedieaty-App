import 'package:flutter/material.dart';
import 'package:hedieaty/core/di/service_locator.dart'; // Dependency injection
import 'package:hedieaty/presentation/routes/app_router.dart'; // Route management
import 'package:hedieaty/core/constants/app_styles.dart'; // Global styling

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  setupServiceLocator();

  runApp(const HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  const HedieatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: AppStyles.appTheme, // Global theme
      initialRoute: RouteNames.login, // Initial route
      onGenerateRoute: AppRouter.onGenerateRoute, // Route generator
    );
  }
}