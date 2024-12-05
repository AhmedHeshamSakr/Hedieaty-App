import 'package:firebase_database/firebase_database.dart';
import '../models/friend_dto.dart';

class FirebaseFriendDataSource {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Future<void> addFriend(FriendDTO friendDTO) async {
    final friendsRef = _database.child('friends').child(friendDTO.userId).child(friendDTO.friendId);
    await friendsRef.set(true);  // True indicates friendship
  }
  Future<List<String>> getFriends(String userId) async {
    final snapshot = await _database.child('friends').child(userId).once();
    final friendsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
    return friendsMap.keys.map((key) => key.toString()).toList();
  }
}