import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../local/datasources/sqlite_user_datasource.dart';
import '../local/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SqliteUserDatasource sqliteUserDatasource; // SQLite datasource instance

  FirebaseAuthService({required this.sqliteUserDatasource})
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  /// Fetch user by ID from Firebase Authentication
  Future<UserModel?> getUserById(String userId) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        return UserModel(
          id: null, // SQLite ID is not used here
          firebaseUid: currentUser.uid,
          name: currentUser.displayName ?? 'Unknown',
          email: currentUser.email ?? 'Unknown',
          preferences: '', // Modify as needed
        );
      }
      return null; // Return null if no match found
    } catch (e) {
      throw Exception('Error fetching user by ID: ${e.toString()}');
    }
  }

  /// Sign up a user with email and password
  Future<User?> signUp(
      String email,
      String password,
      String name,
      Map<String, dynamic> preferences,
      ) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user details in Firestore after successful signup
      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;

        // Add user to Firestore
        await _firestore.collection('users').doc(uid).set({
          'firebase_uid': uid,
          'name': name,
          'email': email,
          'preferences': preferences,
        });

        // Add user to SQLite database
        final UserModel userModel = UserModel(
          id: null, // Let SQLite handle auto-increment ID
          firebaseUid: uid, // Firebase UID
          name: name,
          email: email,
          preferences: preferences.toString(), // Convert preferences to a string
        );
        await sqliteUserDatasource.insertUser(userModel);
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, 'Sign Up Error');
      return null; // Safeguard against incomplete code paths.
    } catch (e) {
      throw Exception('Unexpected Error during Sign Up: ${e.toString()}');
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, 'Sign In Error');
      return null; // Safeguard against incomplete code paths.
    } catch (e) {
      throw Exception('Unexpected Error during Sign In: ${e.toString()}');
    }
  }

  /// Log out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception('Sign Out Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error during Sign Out: ${e.toString()}');
    }
  }

  /// Get the currently signed-in user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Reset the user's password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, 'Reset Password Error');
    } catch (e) {
      throw Exception('Unexpected Error during Password Reset: ${e.toString()}');
    }
  }

  /// Private method to handle FirebaseAuth exceptions
  void _handleAuthException(FirebaseAuthException e, String action) {
    switch (e.code) {
      case 'email-already-in-use':
        throw Exception('$action: Email is already in use.');
      case 'invalid-email':
        throw Exception('$action: Email address is not valid.');
      case 'weak-password':
        throw Exception('$action: Password is too weak.');
      case 'user-not-found':
        throw Exception('$action: No user found with this email.');
      case 'wrong-password':
        throw Exception('$action: Incorrect password.');
      default:
        throw Exception('$action: ${e.message}');
    }
  }
}
