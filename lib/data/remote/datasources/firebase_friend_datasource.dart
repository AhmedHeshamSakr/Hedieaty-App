import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend_dto.dart';

class FirestoreFriendDataSource {
  final CollectionReference _friendsCollection = FirebaseFirestore.instance.collection('friends');

  Future<void> addFriend(FriendDTO friendDTO) async {
    final docId = "${friendDTO.userId}_${friendDTO.friendId}"; // Unique identifier for friendship
    await _friendsCollection.doc(docId).set(friendDTO.toMap());
  }

  Future<List<String>> getFriends(String userId) async {
    final querySnapshot = await _friendsCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['friendId'] as String).toList();
  }
}
