import 'package:firebase_auth/firebase_auth.dart';
import '../local/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService() : _firebaseAuth = FirebaseAuth.instance;


  /// Fetch user by ID from Firebase Authentication
  Future<UserModel?> getUserById(String userId) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      // Check if the current user matches the requested userId
      if (currentUser != null && currentUser.uid == userId) {
        return UserModel(
          id: int.parse(currentUser.uid), // Adjust this based on your UserModel
          name: currentUser.displayName ?? 'Unknown',
          email: currentUser.email ?? 'Unknown', preferences: '',
        );
      }
      return null; // Return null if no match found
    } catch (e) {
      throw Exception('Error fetching user by ID: ${e.toString()}');
    }
  }
  /// Sign up a user with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
