import '../../models/friend_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteFriendDataSource {
  final Database db;

  SQLiteFriendDataSource({required this.db});

  Future<List<FriendModel>> getFriends() async {
    final List<Map<String, dynamic>> maps = await db.query('friends');
    return maps.map((map) => FriendModel.fromJson(map)).toList();
  }

  Future<void> insertFriend(FriendModel friend) async {
    await db.insert(
      'friends',
      friend.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert reciprocal relationship
    final reciprocalFriend = FriendModel(
      userId: friend.friendId,
      friendId: friend.userId,
    );
    await db.insert(
      'friends',
      reciprocalFriend.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isFriendExistsLocally({required String userId, required String friendId}) async {
    final result = await db.query(
      'friends',
      where: 'userId = ? AND friendId = ?',
      whereArgs: [userId, friendId],
    );
    return result.isNotEmpty;
  }


  Future<void> deleteFriend(String friendId ,String userId) async {
    await db.delete('friends', where: 'friendId = ?', whereArgs: [friendId]);
    await db.delete('friends', where: 'friendId = ?', whereArgs: [userId]);

  }
}






