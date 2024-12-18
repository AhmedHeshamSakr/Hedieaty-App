import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../../../domain/entities/friend.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/main_repository.dart';


class FriendsController extends ChangeNotifier {
  final Repository repository;

  FriendsController(this.repository);

  List<User> friendsDetails = [];
  bool isLoading = true;

  // Load friends for the current user
  Future<void> loadFriends() async {
    isLoading = true;
    notifyListeners();

    try {
      final currentUserId = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('No authenticated user');
      }

      // Sync remote and local database
      await repository.syncDatabases(currentUserId);

      // Fetch friends from the local database
      final friends = await repository.getFriends();
      friendsDetails = [];

      for (final friend in friends) {
        final user = await repository.getUser(friend.friendId);
        if (user != null) {
          friendsDetails.add(user);
        }
      }

      debugPrint('Loaded ${friendsDetails.length} friends');
    } catch (e) {
      debugPrint('Error fetching friends: $e');
      friendsDetails = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // Add a friend by email
  Future<void> addFriendByEmail(String email) async {
    try {
      final User? user = await repository.getUserByEmail(email);
      if (user == null) {
        debugPrint('No user found with email: $email');
        return;
      }

      final String currentUserId = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUserId.isEmpty) {
        debugPrint('Current user is not authenticated');
        return;
      }
      debugPrint('Current User ID: $currentUserId');
      debugPrint('Friend User ID: ${user.id}');
      // Check if the friend already exists
      final isFriendAlreadyExists = await repository.isFriendExists(
        userId: currentUserId,
        friendId: user.id,
      );

      if (isFriendAlreadyExists) {
        debugPrint('Already friends with this user');
        return;
      }
      // Add the friend (reciprocal relationship handled in the repository)
      final newFriend = Friend(
        userId: currentUserId,
        friendId: user.id,
      );
      await repository.createFriend(newFriend);
      await loadFriends();
      debugPrint('Friend added successfully');
    } catch (e) {
      debugPrint('Error adding friend: $e');
    }
  }

  // Delete a friend by ID
  Future<void> deleteFriend(String friendId) async {
    try {
      final String currentUserId = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUserId.isEmpty) {
        throw Exception('No authenticated user');
      }

      // Delete friend relationship
      await repository.deleteFriend(friendId);

      // Refresh the local list
      friendsDetails.removeWhere((friend) => friend.id == friendId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting friend: $e');
    }
  }

  void syncFriendsWithRemote(String currentUserId){
     repository.syncFriendsWithRemote(currentUserId);

  }
  Future<void> syncDatabases(String currentUserId)async{
    await repository.syncDatabases(currentUserId);
  }

}
