import 'package:flutter/material.dart';
import 'package:hedieaty/core/di/service_locator.dart'; // Dependency injection
import 'package:hedieaty/presentation/pages/auth/auth_controller.dart';
import 'package:hedieaty/presentation/routes/app_router.dart'; // Route management
import 'package:hedieaty/core/constants/app_styles.dart'; // Global styling
import 'package:hedieaty/presentation/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/utils/firebase_auth_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  // Setup dependency injection
  setupServiceLocator(); // This should include FirebaseAuthService registration
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(serviceLocator<FirebaseAuthService>()), // Pass the FirebaseAuthService instance here
        ),
        // Add other providers if needed
      ],
      child: HedieatyApp(),
    ),
  );
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