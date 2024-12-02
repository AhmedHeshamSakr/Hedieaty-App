import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';
import '../models/gift_model.dart';
import '../models/user_model.dart';


class SqliteUserDatasource {
  final Database database;

  SqliteUserDatasource({required this.database});

  Future<UserModel?> getUserById(String userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> insertUser(UserModel user) async {
    try {
      await database.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error inserting user: ${e.toString()}');
    }
  }


  Future<void> deleteUser(String userId) async {
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<EventModel>> getUserCreatedEvents(String userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => EventModel.fromMap(map)).toList();
  }


  /// Fetch pledged gifts by user ID
  Future<List<GiftModel>> getPledgedGiftsByUser(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'gifts',
        where: 'status = ? AND pledgedByUserId = ?',
        whereArgs: ['pledged', userId],
      );
      return maps.map((map) => GiftModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error fetching pledged gifts for user $userId: ${e.toString()}');
    }
  }

  /// Pledge a gift by updating its status and user association
  Future<void> pledgeGift(String giftId, String userId) async {
    try {
      await database.update(
        'gifts',
        {'status': 'pledged', 'pledgedByUserId': userId},
        where: 'id = ?',
        whereArgs: [giftId],
      );
    } catch (e) {
      throw Exception('Error pledging gift $giftId for user $userId: ${e.toString()}');
    }
  }
}