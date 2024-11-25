import 'package:sqflite/sqflite.dart';
import '../models/friend_model.dart';

class SqliteFriendDatasource {
  final Database database;

  SqliteFriendDatasource(this.database);

  Future<List<FriendModel>> getAllFriends() async {
    final List<Map<String, dynamic>> maps = await database.query('friends');
    return maps.map((map) => FriendModel.fromMap(map)).toList();
  }

  Future<void> insertFriend(FriendModel friend) async {
    await database.insert(
      'friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFriend(int friendId) async {
    await database.delete(
      'friends',
      where: 'id = ?',
      whereArgs: [friendId],
    );
  }
}
