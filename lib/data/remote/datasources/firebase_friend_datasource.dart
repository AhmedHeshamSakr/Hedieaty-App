import 'package:firebase_database/firebase_database.dart';

import '../../models/friend_model.dart';

class FriendRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("friends");

  Future<void> createFriend(FriendModel friend) async {
    await _dbRef.push().set(friend.toJson());
  }

  Future<FriendModel?> getFriendById(String userId, String friendId) async {
    final snapshot = await _dbRef
        .orderByChild("userId")
        .equalTo(userId)
        .get();
    if (snapshot.exists) {
      final friends = Map<String, dynamic>.from(snapshot.value as Map);
      for (var json in friends.values) {
        if (json["friendId"] == friendId) {
          return FriendModel.fromJson(Map<String, dynamic>.from(json));
        }
      }
    }
    return null;
  }

  Future<List<FriendModel>> fetchAllFriends(String userId) async {
    final snapshot = await _dbRef
        .orderByChild("userId")
        .equalTo(userId)
        .get();
    if (snapshot.exists) {
      final friends = Map<String, dynamic>.from(snapshot.value as Map);
      return friends.values.map((json) => FriendModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  Future<void> deleteFriend(String userId, String friendId) async {
    final snapshot = await _dbRef
        .orderByChild("userId")
        .equalTo(userId)
        .get();
    if (snapshot.exists) {
      final friends = Map<String, dynamic>.from(snapshot.value as Map);
      for (var key in friends.keys) {
        if (friends[key]["friendId"] == friendId) {
          await _dbRef.child(key).remove();
          break;
        }
      }
    }
  }
}

