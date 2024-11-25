import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';

class SqliteEventDatasource {
  final Database database;

  SqliteEventDatasource(this.database);

  Future<List<EventModel>> getAllEvents() async {
    final List<Map<String, dynamic>> maps = await database.query('events');
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
}
