import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedieaty/presentation/pages/addFrinds/add_frinds_controller.dart';
import 'package:hedieaty/presentation/pages/gifts/gift_controller.dart';
import 'package:hedieaty/presentation/pages/home/home_controller.dart';
import 'package:hedieaty/presentation/pages/pledged_gifts/pledge_controller.dart';
import 'package:hedieaty/presentation/pages/profile/profile_controller.dart';
import 'package:hedieaty/presentation/routes/navigation_service.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart'; // Dependency injection
import 'core/constants/app_styles.dart'; // Global styles
import 'data/local/database_helper.dart';
import 'data/utils/firebase_auth_service.dart'; // Firebase auth service
import 'presentation/pages/auth/auth_controller.dart'; // Authentication controller
import 'presentation/pages/events/event_controller.dart'; // Event list controller
import 'presentation/routes/app_router.dart'; // Route management
import 'presentation/routes/route_names.dart'; // Route names

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    rethrow;
  }

  try{
    final database = await DatabaseHelper.instance.database;
    // Optional: Log all tables for debugging
    final tables = await database.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    print('Database tables: $tables');
  }catch(e){
    debugPrint("sql initialization failed: $e");
  }



  // Setup dependency injection
  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(serviceLocator<FirebaseAuthService>())
        ),
        ChangeNotifierProvider<EventListController>(
          create: (_) => EventListController()
        ),
        ChangeNotifierProvider<HomePageController>(
          create: (_) => HomePageController()
        ),
        ChangeNotifierProvider<GiftController>(
           create: (_) => GiftController()
        ),
        ChangeNotifierProvider<UserController>(
           create: (_) => UserController()
        ),
        ChangeNotifierProvider<PledgedGiftsController>(
           create: (_) => PledgedGiftsController()
        ),
        ChangeNotifierProvider<FriendsController>(
           create: (_) => FriendsController(),
        ),
      ],
      child: const HedieatyApp(),
    ),
  );
}

class HedieatyApp extends StatelessWidget {
  const HedieatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: AppStyles.lightTheme, // Light theme
      darkTheme: AppStyles.darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Automatically use system theme
      initialRoute: RouteNames.login, // Initial route
      onGenerateRoute: AppRouter.onGenerateRoute, // Handles route generation
      navigatorKey: NavigationService().navigatorKey, // Add this line

    );
  }
}
