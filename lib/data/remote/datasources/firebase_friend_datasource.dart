import 'package:firebase_database/firebase_database.dart';

import '../../models/friend_model.dart';

import 'package:firebase_auth/firebase_auth.dart';


class FriendRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("friends");

  Future<void> createFriend(FriendModel friend) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    // Add friendId under userId
    await _dbRef.child(friend.userId).child(friend.friendId).set(true);
    // Add reciprocal relationship
    await _dbRef.child(friend.friendId).child(friend.userId).set(true);
  }

  Future<bool> isFriendExistsRemotely({required String userId, required String friendId,}) async {
    final snapshot = await _dbRef.child(userId).child(friendId).get();
    return snapshot.exists;
  }

  Future<List<FriendModel>> fetchAllFriends() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    try {
      // Fetch the friend IDs under the current user's ID
      final snapshot = await _dbRef.child(currentUser.uid).get();
      if (snapshot.exists) {
        // Extract friendIds
        final friendsMap = snapshot.value as Map<dynamic, dynamic>;
        return friendsMap.keys.map((friendId) {
          return FriendModel(
            userId: currentUser.uid,
            friendId: friendId.toString(),
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  Future<FriendModel?> getFriendById(String userId, String friendId) async {
    final snapshot = await _dbRef.child(userId).child(friendId).get();
    if (snapshot.exists) {
      return FriendModel(userId: userId, friendId: friendId);
    }
    return null;
  }

  Future<void> deleteFriend(String userId, String friendId) async {
    // Remove friendId under userId
    await _dbRef.child(userId).child(friendId).remove();

    // Remove reciprocal relationship
    await _dbRef.child(friendId).child(userId).remove();
  }
}
