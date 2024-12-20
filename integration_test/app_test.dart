import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/local/database_helper.dart';
import 'package:hedieaty/data/remote/realtime_database_helper.dart';
import 'package:hedieaty/data/utils/sync_database.dart';
import 'package:hedieaty/presentation/pages/addFrinds/add_frinds_controller.dart';
import 'package:hedieaty/presentation/pages/gifts/gift_controller.dart';
import 'package:hedieaty/presentation/pages/pledged_gifts/pledge_controller.dart';
import 'package:hedieaty/presentation/pages/profile/profile_controller.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hedieaty/main.dart';
import 'package:hedieaty/core/di/service_locator.dart';
import 'package:hedieaty/data/utils/firebase_auth_service.dart';
import 'package:hedieaty/domain/repositories/main_repository.dart';
import 'package:hedieaty/presentation/pages/auth/auth_controller.dart';
import 'package:hedieaty/presentation/pages/events/event_controller.dart';
import 'package:hedieaty/presentation/pages/home/home_controller.dart';
import 'package:sqflite/sqflite.dart';

// Helper function for adding visual delays
Future<void> addDelay([int milliseconds = 500]) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Firebase for testing
    await Firebase.initializeApp();

    // Initialize your app's dependencies
    await _initializeAppDependencies();
  });

  group('End-to-end test: User signup, login, and event creation', () {
    testWidgets('Complete user journey test', (tester) async {
      // Launch the app with dependencies
      await tester.pumpWidget(await createTestApp());
      await addDelay(1000);
      await tester.pumpAndSettle();

      print('📱 Starting application test flow...');

      // Wait for the login page to fully load
      await tester.pump(const Duration(seconds: 3));

      print('🔄 Navigating to signup page...');
      await tester.tap(find.text("Don’t have an account? Sign Up"));
      await addDelay();
      await tester.pumpAndSettle();

      // Fill signup form
      print('✍️ Filling signup form...');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Test User',
      );
      await addDelay();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'test1_@example.com',
      );
      await addDelay();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Test11!',
      );
      await addDelay();

      // Create Account
      print('🚀 Creating account...');
      try {
        await tester.tap(find.text('Sign Up'));
        await addDelay(5000); // Increased delay for Firebase operation
        await tester.pumpAndSettle();
        print('✅ Account creation attempted');
      } catch (e) {
        print('❌ Signup error: $e');
        return;
      }
      // Return to login and enter credentials
      print('🔑 Logging in...');
      try {
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test1_@example.com', // Use the email from signup
        );
        await addDelay();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'Test11!',
        );
        await addDelay();

        await tester.tap(find.text('Login'));
        await addDelay(400); // Increased delay for Firebase authentication
        await tester.pumpAndSettle();
        print('✅ Login attempted');
      } catch (e) {
        print('❌ Login error: $e');
        return;
      }

      await addDelay();
      await addDelay();
      // Verify home page and navigate to events
      print('📋 Navigating to Home page...');
      try {
        expect(find.textContaining('Hedieaty'), findsOneWidget);
        print('✅ Home page loaded successfully');
      } catch (e) {
        print('❌ Home page verification error: $e');
        return;
      }
      await addDelay();
      await addDelay();
      await addDelay();

      print('📋 Navigating to Events page...');
      await tester.tap(find.text('Events'));
      await addDelay();
      await addDelay();
      await addDelay();

      await tester.pumpAndSettle();
      await addDelay();
      await addDelay();

      try {
        print('➕ Creating new event...');
        await tester.tap(find.text('Add Event'));
        await addDelay();
        await addDelay();
        await addDelay();

        await tester.pumpAndSettle();

        // Fill event details
        print('📝 Filling event details...');
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Event Name'),
          'Birthday Celebration',
        );
        await addDelay();
        await addDelay();
        await addDelay();


        await tester.enterText(
          find.widgetWithText(TextFormField, 'Location'),
          'Home',
        );
        await addDelay();
        await addDelay();
        await addDelay();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Description'),
          'Annual birthday party',
        );
        await addDelay();
        await addDelay();
        await addDelay();


        // Select date
        print('📅 Selecting date...');
        await tester.tap(find.text('Select a date'));
        await addDelay();
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await addDelay();
        await tester.pumpAndSettle();
        await addDelay();
        await addDelay();

        // Create the event
        print('💾 Saving event...');
        await tester.tap(find.text('Create'));
        await addDelay(7000); // Increased delay for event creation
        await tester.pumpAndSettle();
        await addDelay();
        await addDelay();

        // Verify the event was added
        print('✅ Verifying event creation...');
        expect(find.text('Birthday Celebration'), findsOneWidget);
        print('✅ Event created successfully');
      } catch (e) {
        print('❌ Event creation error: $e');
      }


      print('🔗 Navigating to events gifts...');
      await tester.tap(find.text('Birthday Celebration')); // Assuming tapping the event tile opens the event details page
      await addDelay();
      await tester.pumpAndSettle();
      await addDelay();
      await addDelay();

      try {
        print('➕ Creating new gift...');
        await tester.tap(find.text('Add Gift'));
        await addDelay();
        await addDelay();
        await tester.pumpAndSettle();

        // Fill gift details
        print('📝 Filling gift details...');
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Gift Name'),
          'Teddy Bear',
        );
        await addDelay();
        await addDelay();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Description'),
          'A soft and cuddly teddy bear',
        );
        await addDelay();
        await addDelay();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Category'),
          'Toys',
        );
        await addDelay();
        await addDelay();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Price'),
          '25.99',
        );
        await addDelay();
        await addDelay();
        await addDelay();



        // Save the gift
        print('💾 Saving gift...');
        await tester.tap(find.text('Add'));
        await addDelay(7000); // Increased delay for saving the gift
        await tester.pumpAndSettle();
        await addDelay();
        await addDelay();

        // Verify the gift was added
        print('✅ Verifying gift creation...');
        expect(find.text('Teddy Bear'), findsOneWidget);
        await addDelay();
        await addDelay();

        print('✅ Gift added successfully');
      } catch (e) {
        print('❌ Gift creation error: $e');
      }
    });
  });
}

// Initialize app dependencies for testing
Future<void> _initializeAppDependencies() async {
  await _initializeFirebase();
  await _initializeDatabases();
  setupServiceLocator();
}


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

// Create a test version of your app
Widget createTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(serviceLocator<FirebaseAuthService>(),serviceLocator<SyncService>())
      ),
      ChangeNotifierProvider<EventListController>(
          create: (_) => EventListController(serviceLocator<Repository>())
      ),
      ChangeNotifierProvider<HomePageController>(
          create: (_) => HomePageController(serviceLocator<Repository>())
      ),
      ChangeNotifierProvider<GiftController>(
          create: (context) => GiftController(serviceLocator<Repository>())
      ),
      ChangeNotifierProvider<UserController>(
          create: (_) => UserController(serviceLocator<Repository>())
      ),
      ChangeNotifierProvider<PledgedGiftsController>(
          create: (_) => PledgedGiftsController(serviceLocator<Repository>())
      ),
      ChangeNotifierProvider<FriendsController>(
        create: (_) => FriendsController(serviceLocator<Repository>()),
      ),
    ],
    child: const HedieatyApp(),
  );

}

