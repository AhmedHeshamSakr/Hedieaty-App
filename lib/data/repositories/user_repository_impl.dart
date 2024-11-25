import '../../domain/repositories/user_repository.dart';
import '../local/datasources/sqlite_user_datasource.dart';
import '../utils/firebase_auth_service.dart';
import '../local/models/user_model.dart';



class UserRepositoryImpl implements UserRepository{
  final SqliteUserDatasource localDatasource;
  final FirebaseAuthService remoteAuthService;

  UserRepositoryImpl(this.localDatasource, this.remoteAuthService);

  /// Fetch a user's profile from local SQLite or Firebase
  @override
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      // Attempt to fetch the user from the local database
      final localUser = await localDatasource.getUserById(int.parse(userId));
      if (localUser != null) return localUser;

      // Fetch from Firebase if not found locally
      final remoteUser = await remoteAuthService.getUserById(userId);
      if (remoteUser != null) {
        // Save the fetched user to the local database for future use
        await localDatasource.insertUser(remoteUser);
        return remoteUser;
      }

      return null; // Return null if user is not found in either source
    } catch (e) {
      throw Exception('Error fetching user profile: ${e.toString()}');
    }
  }

  /// Update a user's profile in the local SQLite database
  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await localDatasource.updateUser(user);
    } catch (e) {
      throw Exception('Error updating user profile: ${e.toString()}');
    }
  }

  /// Sign in a user using Firebase Authentication
  @override
  Future<void> signIn(String email, String password) async {
    try {
      await remoteAuthService.signIn(email, password);
    } catch (e) {
      throw Exception('Error signing in: ${e.toString()}');
    }
  }

  /// Sign out the current user from Firebase Authentication
  Future<void> signOut() async {
    try {
      await remoteAuthService.signOut();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  /// Delete a user profile from the local SQLite database
  Future<void> deleteUser(String userId) async {
    try {
      await localDatasource.deleteUser(userId);
    } catch (e) {
      throw Exception('Error deleting user: ${e.toString()}');
    }
  }
}
