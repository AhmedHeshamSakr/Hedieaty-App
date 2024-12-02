import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';

class SqliteEventDatasource {
  final Database database;

  SqliteEventDatasource(this.database);

  Future<List<EventModel>> getAllEvents({String? sortBy, String? status}) async {
    String whereClause = '';
    List<String> whereArgs = [];

    if (status != null) {
      whereClause = 'status = ?';
      whereArgs.add(status);
    }

    final List<Map<String, dynamic>> maps = await database.query(
      'events',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: sortBy,
    );
    return maps.map((map) => EventModel.fromMap(map)).toList();
  }

  Future<void> insertEvent(EventModel event) async {
    await database.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(EventModel event) async {
    await database.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(int eventId) async {
    await database.delete(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<EventModel>> getEventsByUserId(int userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => EventModel.fromMap(map)).toList();
  }

  Future<List<EventModel>> getFriendEvents(int friendId) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'events',
        where: 'friendId = ?', // Adjust if using a join table
        whereArgs: [friendId],
      );
      return maps.map((map) => EventModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error fetching friend events: ${e.toString()}');
    }
  }


}