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
    await db.insert('friends', friend.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFriend(String friendId) async {
    await db.delete('friends', where: 'friendId = ?', whereArgs: [friendId]);
  }
}







// import 'package:sqflite/sqflite.dart';
// import '../models/event_model.dart';
// import '../models/friend_model.dart';
//
// class SqliteFriendDatasource {
//   final Database database;
//
//   SqliteFriendDatasource(this.database);
//
//   Future<List<FriendModel>> getAllFriends() async {
//     final List<Map<String, dynamic>> maps = await database.query('friends');
//     return maps.map((map) => FriendModel.fromMap(map)).toList();
//   }
//
//   Future<void> insertFriend(FriendModel friend) async {
//     await database.insert(
//       'friends',
//       friend.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> deleteFriend(int friendId) async {
//     await database.delete(
//       'friends',
//       where: 'id = ?',
//       whereArgs: [friendId],
//     );
//   }
//
//   Future<List<FriendModel>> searchFriendsByName(String name) async {
//     final List<Map<String, dynamic>> maps = await database.query(
//       'friends',
//       where: 'name LIKE ?',
//       whereArgs: ['%$name%'],
//     );
//     return maps.map((map) => FriendModel.fromMap(map)).toList();
//   }
//
//   Future<List<EventModel>> getFriendEvents(int friendId) async {
//     try {
//       // Assuming the events table has "friendId" as a foreign key
//       final List<Map<String, dynamic>> maps = await database.rawQuery('''
//       SELECT *
//       FROM events
//       WHERE friendId = ?
//     ''', [friendId]);
//       return maps.map((map) => EventModel.fromMap(map)).toList();
//     } catch (e) {
//       throw Exception('Error fetching friend events: ${e.toString()}');
//     }
//   }
// }