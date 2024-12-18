import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

import '../../core/utils/validators.dart';
import '../local/datasources/sqlite_user_datasource.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final DatabaseReference _databaseReference;
  final SqliteUserDatasource sqliteUserDatasource;

  FirebaseAuthService({required this.sqliteUserDatasource})
      : _firebaseAuth = FirebaseAuth.instance,
        _databaseReference = FirebaseDatabase.instance.ref();

  /// Fetch user by ID from Firebase Authentication and Realtime Database
  Future<UserModel?> getUserById(String userId) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return null;

      // Ensure the requested user matches the current authenticated user
      if (currentUser.uid != userId) {
        throw Exception('Unauthorized access to user data');
      }

      // Fetch user data from Realtime Database
      final userSnapshot = await _databaseReference.child('users/$userId').get();
      if (!userSnapshot.exists) return null;

      final data = Map<String, dynamic>.from(userSnapshot.value as Map);

      // Create UserModel with comprehensive data mapping
      return UserModel(
        id: userId, // Use Firebase UID as identifier
        name: data['name'] ?? 'Unknown',
        email: currentUser.email ?? 'Unknown',
        preferences: json.encode(data['preferences'] ?? {}),
      );
    } catch (e) {
      // Log the error (consider adding a proper logging mechanism)
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  /// Sign up a user with comprehensive error handling and data synchronization
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      Validators.validateEmail(email);
      Validators.validatePassword(password);
      // Default preferences if not provided
      final userPreferences = preferences ?? {};

      // Create user in Firebase Authentication
      final UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('User creation failed');
      }

      // Prepare user data for Realtime Database
      final userData = {
        'firebase_uid': firebaseUser.uid,
        'name': name,
        'email': email,
        'preferences': userPreferences,
        'created_at': ServerValue.timestamp,
      };

      // Store user details in Realtime Database
      await _databaseReference.child('users/${firebaseUser.uid}').set(userData);

      // Create local UserModel
      final localUser = UserModel(
        id: firebaseUser.uid,
        name: name,
        email: email,
        preferences: json.encode(userPreferences),
      );

      // Insert user into local SQLite database
      await sqliteUserDatasource.insertUser(localUser);

      return localUser;
    } on FirebaseAuthException catch (e) {
      // Centralized exception handling
      _handleAuthException(e, 'Sign Up Error');
      return null;
    } catch (e) {
      print('Unexpected Sign Up Error: $e');
      rethrow;
    }
  }

  /// Sign in method with improved error handling
  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Basic input validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Authentication failed');
      }

      // Fetch and sync user data
      final userModel = await getUserById(firebaseUser.uid);
      if (userModel != null) {
        await sqliteUserDatasource.updateUser(userModel);
        return userModel;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, 'Sign In Error');
      return null;
    } catch (e) {
      print('Unexpected Sign In Error: $e');
      rethrow;
    }
  }

  /// Log out the current user with additional cleanup
  Future<void> signOut() async {
    try {
      // Clear local SQLite user data (optional, depends on your app's requirements)
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await sqliteUserDatasource.deleteUser(currentUser.uid);
      }
      // Sign out from Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      rethrow;
    }
  }

  /// Reset password with comprehensive error handling
  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, 'Reset Password Error');
    } catch (e) {
      print('Unexpected Password Reset Error: $e');
      rethrow;
    }
  }

  /// Get the currently signed-in user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Private method to handle FirebaseAuth exceptions
  void _handleAuthException(FirebaseAuthException e, String action) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email is already registered';
        break;
      case 'invalid-email':
        errorMessage = 'Invalid email address';
        break;
      case 'weak-password':
        errorMessage = 'Password is too weak';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password';
        break;
      default:
        errorMessage = e.message ?? 'An unknown error occurred';
    }

    throw Exception('$action: $errorMessage');
  }
}