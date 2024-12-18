
import 'package:flutter/cupertino.dart';

import '../../models/gift_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteGiftDataSource {
  final Database db;

  SQLiteGiftDataSource({required this.db});

  Future<List<GiftModel>> getGifts(String eventId) async {
    final List<Map<String, dynamic>> maps = await db.query(
        'gifts', where: 'eventId = ?', whereArgs: [eventId]);
    return maps.map((map) => GiftModel.fromJson(map)).toList();
  }

  Future<GiftModel?> getGiftById(String giftId) async {
    final List<Map<String, dynamic>> maps = await db.query(
        'gifts',
        where: 'id = ?',
        whereArgs: [giftId]
    );
    return maps.isNotEmpty ? GiftModel.fromJson(maps.first) : null;
  }



  Future<List<GiftModel>> getGiftsByUserId(String userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'gifts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => GiftModel.fromJson(map)).toList();
  }

  Future<void> insertGift(GiftModel gift) async {
    await db.insert(
      'gifts',
      gift.toJson()
        ..update('gifterId', (value) => value?.isEmpty == true ? null : value),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteGift(String id) async {
    await db.delete('gifts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<GiftModel>> getGiftsByEventAndStatus(String eventId,
      String status) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'gifts',
      where: 'eventId = ? AND status = ?',
      whereArgs: [eventId, status],
    );
    return maps.map((map) => GiftModel.fromJson(map)).toList();
  }

  Future<GiftModel?> updateGift(GiftModel gift) async {
    await db.update(
        'gifts', gift.toJson(), where: 'id = ?', whereArgs: [gift.id]);
  }

  Future<void> pledgeGift(String giftId, String gifterId) async {
    try {
      await db.update(
        'gifts',
        {'gifterId': gifterId, 'status': 'Pledged'},
        where: 'id = ?',
        whereArgs: [giftId],
      );
      debugPrint('Gift $giftId pledged successfully by $gifterId');
    } catch (e) {
      debugPrint('Error pledging gift $giftId: $e');
      throw Exception('Failed to pledge gift $giftId');
    }
  }

  Future<void> unpledgeGift(String giftId) async {
    try {
      await db.update(
        'gifts',
        {'gifterId': null, 'status': 'Available'},
        where: 'id = ?',
        whereArgs: [giftId],
      );
      debugPrint('Gift $giftId unpledged successfully');
    } catch (e) {
      debugPrint('Error unpledging gift $giftId: $e');
      throw Exception('Failed to unpledge gift $giftId');
    }
  }

  Future<void> clearGiftsByEvent(String eventId) async {
    try {
      // Deleting all gifts where the eventId matches the provided eventId
      await db.delete(
        'gifts',
        where: 'eventId = ?',
        whereArgs: [eventId],
      );
      debugPrint('Successfully cleared gifts for eventId: $eventId');
    } catch (e) {
      debugPrint('Error clearing gifts for eventId: $eventId - $e');
      throw Exception('Failed to clear gifts for eventId: $eventId');
    }
  }
}