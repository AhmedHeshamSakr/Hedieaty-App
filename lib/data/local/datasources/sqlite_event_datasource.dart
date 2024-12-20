import '../../../domain/entities/event.dart';
import '../../models/event_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteEventDataSource {
  final Database db;

  SQLiteEventDataSource({required this.db});

  Future<List<EventModel>> getEvents() async {
    final List<Map<String, dynamic>> maps = await db.query('events');
    return maps.map((map) => EventModel.fromJson(map)).toList();
  }

  Future<List<EventModel>> getEventsByUserId(String userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'events', where: 'userId = ?', whereArgs: [userId],);
    return maps.map((map) => EventModel.fromJson(map)).toList();
  }

  Future<void> insertEvent(EventModel event) async {
    // Ensure the event has a valid ID before insertion
    if (event.id.isEmpty) {
      throw Exception('Cannot insert event without a valid ID');
    }
    await db.insert(
        'events', event.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<EventModel?> getEventById(String eventId) async {
    try {
      // Query the events table to find an event with the matching ID
      final List<Map<String, dynamic>> results = await db.query(
          'events',
          where: 'id = ?',
          whereArgs: [eventId],
          limit: 1
      );

      // If no event is found, return null
      if (results.isEmpty) {
        return null;
      }

      // Convert the database result to an EventModel
      return EventModel.fromJson(results.first);
    } catch (e) {
      // Log the error for debugging
      print('Error fetching event by ID: $e');

      // Optionally rethrow or handle the error as needed
      throw Exception('Failed to retrieve event: $e');
    }
  }


  Future<void> updateEvent(EventModel event) async {
    await db.update(
        'events', event.toJson(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<void> deleteEvent(String id) async {
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

}