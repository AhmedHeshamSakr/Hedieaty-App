import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../local/datasources/sqlite_user_datasource.dart';
import '../remote/datasources/firebase_user_datasource.dart';
import '../models/user_model.dart';
import '../remote/realtime_database_helper.dart';

class SyncService {
  final SqliteUserDatasource _localUserDataSource;
  final RealTimeDatabaseHelper _remoteDatabaseHelper;

  SyncService(this._localUserDataSource, this._remoteDatabaseHelper);

  // Main synchronization method to be called after login
  Future<UserModel?> syncUserData() async {
    try {
      // Get current authenticated user
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user data from remote database
      final remoteUser = await _remoteDatabaseHelper.getUserById(currentUser.uid);

      if (remoteUser == null) {
        // If user doesn't exist in remote database, create new user
        final newUser = UserModel(
          id: currentUser.uid,
          name: currentUser.displayName ?? 'New User',
          email: currentUser.email ?? '',
          preferences: {}.toString(), // Default preferences
        );
        // Save to remote first
        await _remoteDatabaseHelper.createUser(newUser);
        // Then save to local
        await _localUserDataSource.insertUser(newUser);

        return newUser;
      }

      // Update local database with remote data
      await _localUserDataSource.insertUser(remoteUser);

      // Check for and sync any local changes that weren't synced
      await _syncLocalChanges(currentUser.uid);

      return remoteUser;
    } catch (e) {
      // If remote sync fails, try to get user from local database
      final localUser = await _getLocalUser();
      if (localUser != null) {
        return localUser;
      }

      // Re-throw the error if we couldn't get the user from either source
      rethrow;
    }
  }

  // Helper method to get user from local database
  Future<UserModel?> _getLocalUser() async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    try {
      return await _localUserDataSource.getUser(currentUser.uid);
    } catch (e) {
      return null;
    }
  }

  // Helper method to sync any local changes to remote
  Future<void> _syncLocalChanges(String userId) async {
    try {
      final localUser = await _localUserDataSource.getUser(userId);
      final remoteUser = await _remoteDatabaseHelper.getUserById(userId);

      if (localUser != null && remoteUser != null) {
        // Compare timestamps or version numbers if you have them
        // For now, we'll just ensure the remote database has the latest data
        await _remoteDatabaseHelper.updateUser(userId, localUser);
      }
    } catch (e) {
      // Log the error but don't throw - this is a background sync
      print('Error syncing local changes: $e');
    }
  }

  // Method to handle user data updates during the session
  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      // Update remote first
      await _remoteDatabaseHelper.updateUser(updatedUser.id, updatedUser);
      // Then update local
      await _localUserDataSource.updateUser(updatedUser);
    } catch (e) {
      // If remote update fails, update local and mark for sync later
      await _localUserDataSource.updateUser(updatedUser);
      // You could add a sync queue here for failed remote updates
      throw Exception('Failed to sync user update to remote: $e');
    }
  }
}