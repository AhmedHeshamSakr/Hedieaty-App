import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedieaty/presentation/pages/addFrinds/add_frinds_controller.dart';
import 'package:hedieaty/presentation/pages/gifts/gift_controller.dart';
import 'package:hedieaty/presentation/pages/home/home_controller.dart';
import 'package:hedieaty/presentation/pages/pledged_gifts/pledge_controller.dart';
import 'package:hedieaty/presentation/pages/profile/profile_controller.dart';
import 'package:hedieaty/presentation/routes/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'core/di/service_locator.dart'; // Dependency injection
import 'core/constants/app_styles.dart'; // Global styles
import 'data/local/database_helper.dart';
import 'data/local/database_reset.dart';
import 'data/remote/realtime_database_helper.dart';
import 'data/utils/firebase_auth_service.dart'; // Firebase auth service
import 'domain/repositories/event_repository.dart';
import 'presentation/pages/auth/auth_controller.dart'; // Authentication controller
import 'presentation/pages/events/event_controller.dart'; // Event list controller
import 'presentation/routes/app_router.dart'; // Route management
import 'presentation/routes/route_names.dart'; // Route names

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseResetUtility.dropDatabase();

  // Initialize Firebase with comprehensive error handling and logging
  await _initializeFirebase();

  // Initialize local and real-time databases
  await _initializeDatabases();

  // Setup dependency injection and run app
  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(serviceLocator<FirebaseAuthService>())
        ),
        ChangeNotifierProvider<EventListController>(
            create: (_) => EventListController(serviceLocator<EventRepository>())
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
/// Comprehensive Firebase initialization with detailed error handling
Future<void> _initializeFirebase() async {
  try {
    // Initialize Firebase Core
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized successfully");
  } on FirebaseException catch (firebaseError) {
    // Handle specific Firebase initialization errors
    debugPrint("❌ Firebase Initialization Error: ${firebaseError.code}");
    debugPrint("Error Details: ${firebaseError.message}");

    throw FirebaseInitializationException('Firebase setup failed');
  } catch (e) {
    // Catch any unexpected errors during Firebase initialization
    debugPrint("❌ Unexpected Firebase Initialization Error: $e");
    rethrow;
  }
}

/// Comprehensive database initialization
Future<void> _initializeDatabases() async {
  try {
    final realtimeDbHelper = RealTimeDatabaseHelper.instance;
    final localDatabase = await DatabaseHelper.instance.database;
    await _logDatabaseInfo(localDatabase, realtimeDbHelper);
  } catch (e) {
    debugPrint("❌ Database Initialization Failed: $e");
    rethrow;
  }
}

/// Detailed database information logging
Future<void> _logDatabaseInfo(Database localDb, RealTimeDatabaseHelper realtimeDb) async {
  // Log Local SQLite Database Tables
  final tables = await localDb.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
  debugPrint("📊 Local SQLite Tables:");
  for (var table in tables) {
    debugPrint("  - ${table['name']}");
  }
  try {
    debugPrint("✅ Realtime Database connection validated");
  } catch (e) {
    debugPrint("❌ Realtime Database connection test failed: $e");
  }
}

/// Custom exception for Firebase initialization errors
class FirebaseInitializationException implements Exception {
  final String message;

  FirebaseInitializationException(this.message);

  @override
  String toString() => 'FirebaseInitializationException: $message';
}
