import 'package:sqflite/sqflite.dart';
import '../models/gift_model.dart';

class SqliteGiftDatasource {
  final Database database;

  SqliteGiftDatasource(this.database);

  Future<List<GiftModel>> getGiftsByEventId(int eventId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'gifts',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return maps.map((map) => GiftModel.fromMap(map)).toList();
  }

  Future<void> insertGift(GiftModel gift) async {
    await database.insert(
      'gifts',
      gift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateGift(GiftModel gift) async {
    await database.update(
      'gifts',
      gift.toMap(),
      where: 'id = ?',
      whereArgs: [gift.id],
    );
  }

  Future<void> deleteGift(int giftId) async {
    await database.delete(
      'gifts',
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }
}
