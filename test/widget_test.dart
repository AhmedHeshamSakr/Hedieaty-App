import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/main.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test: User signup, login, and event creation', () {
    testWidgets('Complete user journey test', (tester) async {
      // Launch the app
      await tester.pumpWidget( HedieatyApp());
      await tester.pumpAndSettle();

      // Step 1: Navigate to signup page and create account
      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      // Fill in signup form
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'),
          'Test User'
      );
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'test@example.com'
      );
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'Test123!'
      );

      // Submit signup form
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Step 2: Login with created credentials
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com'
      );
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'Test123!'
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify we're on the home page
      expect(find.text('Welcome, Test User'), findsOneWidget);

      // Step 3: Navigate to event list
      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();

      // Step 4: Tap add event button
      await tester.tap(find.text('Add Event'));
      await tester.pumpAndSettle();

      // Step 5: Fill in event details
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Event Name'),
          'Test Event'
      );
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Location'),
          'Test Location'
      );
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Description'),
          'Test Description'
      );

      // Select date
      await tester.tap(find.text('Select a date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Create the event
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify the event was added to the list
      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });
  });
}