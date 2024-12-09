
import '../../models/gift_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteGiftDataSource {
  final Database db;

  SQLiteGiftDataSource({required this.db});

  Future<List<GiftModel>> getGifts(String eventId) async {
    final List<Map<String, dynamic>> maps = await db.query('gifts', where: 'eventId = ?', whereArgs: [eventId]);
    return maps.map((map) => GiftModel.fromJson(map)).toList();
  }

  Future<void> insertGift(GiftModel gift) async {
    await db.insert('gifts', gift.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateGift(GiftModel gift) async {
    await db.update('gifts', gift.toJson(), where: 'id = ?', whereArgs: [gift.id]);
  }

  Future<void> deleteGift(String id) async {
    await db.delete('gifts', where: 'id = ?', whereArgs: [id]);
  }
}

































// import 'package:sqflite/sqflite.dart';
// import '../models/gift_model.dart';
//
// class SqliteGiftDatasource {
//   final Database database;
//
//   SqliteGiftDatasource(this.database);
//
//   Future<List<GiftModel>> getGiftsByEventId(int eventId, {String? sortBy}) async {
//     final List<Map<String, dynamic>> maps = await database.query(
//       'gifts',
//       where: 'eventId = ?',
//       whereArgs: [eventId],
//       orderBy: sortBy,
//     );
//     return maps.map((map) => GiftModel.fromMap(map)).toList();
//   }
//
//   Future<void> insertGift(GiftModel gift) async {
//     await database.insert(
//       'gifts',
//       gift.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> updateGift(GiftModel gift) async {
//     await database.update(
//       'gifts',
//       gift.toMap(),
//       where: 'id = ?',
//       whereArgs: [gift.id],
//     );
//   }
//
//   Future<void> deleteGift(int giftId) async {
//     await database.delete(
//       'gifts',
//       where: 'id = ?',
//       whereArgs: [giftId],
//     );
//   }
//
//   Future<List<GiftModel>> getPledgedGiftsByUser(int userId) async {
//     final List<Map<String, dynamic>> maps = await database.query(
//       'gifts',
//       where: 'pledgedBy = ?',
//       whereArgs: [userId],
//     );
//     return maps.map((map) => GiftModel.fromMap(map)).toList();
//   }
//
//   Future<void> pledgeGift(int giftId, int userId) async {
//     await database.update(
//       'gifts',
//       {'status': 'pledged', 'pledgedBy': userId},
//       where: 'id = ?',
//       whereArgs: [giftId],
//     );
//   }
// }