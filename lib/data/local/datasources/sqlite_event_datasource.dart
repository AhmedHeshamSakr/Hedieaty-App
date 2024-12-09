import '../../models/event_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteEventDataSource {
  final Database db;

  SQLiteEventDataSource({required this.db});

  Future<List<EventModel>> getEvents() async {
    final List<Map<String, dynamic>> maps = await db.query('events');
    return maps.map((map) => EventModel.fromJson(map)).toList();
  }

  Future<void> insertEvent(EventModel event) async {
    await db.insert('events', event.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateEvent(EventModel event) async {
    await db.update('events', event.toJson(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<void> deleteEvent(String id) async {
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}




// import 'package:sqflite/sqflite.dart';
// import '../models/event_model.dart';
//
// class SqliteEventDatasource {
//   final Database database;
//
//   SqliteEventDatasource({required this.database});
//
//   Future<List<EventModel>> getAllEvents({String? sortBy, String? status}) async {
//     String whereClause = '';
//     List<String> whereArgs = [];
//
//     if (status != null) {
//       whereClause = 'status = ?';
//       whereArgs.add(status);
//     }
//
//     final List<Map<String, dynamic>> maps = await database.query(
//       'events',
//       where: whereClause.isNotEmpty ? whereClause : null,
//       whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
//       orderBy: sortBy,
//     );
//     return maps.map((map) => EventModel.fromMap(map)).toList();
//   }
//
//   Future<int> insertEvent(EventModel event) async {
//     return await database.insert(
//       'events',
//       event.toMap()..remove('id'),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> updateEvent(EventModel event) async {
//     await database.update(
//       'events',
//       event.toMap(),
//       where: 'id = ?',
//       whereArgs: [event.id],
//     );
//   }
//
//   Future<void> deleteEvent(int eventId) async {
//     await database.delete(
//       'events',
//       where: 'id = ?',
//       whereArgs: [eventId],
//     );
//   }
//
//   Future<List<EventModel>> getEventsByUserId(int userId) async {
//     final List<Map<String, dynamic>> maps = await database.query(
//       'events',
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return maps.map((map) => EventModel.fromMap(map)).toList();
//   }
//
//   Future<List<EventModel>> getFriendEvents(int friendId) async {
//     try {
//       final List<Map<String, dynamic>> maps = await database.query(
//         'events',
//         where: 'friendId = ?', // Adjust if using a join table
//         whereArgs: [friendId],
//       );
//       return maps.map((map) => EventModel.fromMap(map)).toList();
//     } catch (e) {
//       throw Exception('Error fetching friend events: ${e.toString()}');
//     }
//   }
//   // New method to clear all events during synchronization
//   Future<void> clearAllEvents(Transaction? txn) async {
//     try {
//       if (txn != null) {
//         // Use provided transaction
//         await txn.delete('events');
//       } else {
//         // If no transaction provided, use database directly
//         await database.delete('events');
//       }
//     } catch (e) {
//       throw Exception('Failed to clear events: ${e.toString()}');
//     }
//   }
//
//   // New method to insert event within a transaction
//   Future<void> insertEventInTransaction(EventModel event, Transaction txn) async {
//     try {
//       await txn.insert(
//         'events',
//         event.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } catch (e) {
//       throw Exception('Failed to insert event in transaction: ${e.toString()}');
//     }
//   }
//
//   // Enhanced method with more robust error handling
//   Future<EventModel?> getEventById(int eventId) async {
//     try {
//       final List<Map<String, dynamic>> maps = await database.query(
//         'events',
//         where: 'id = ?',
//         whereArgs: [eventId],
//         limit: 1,
//       );
//
//       return maps.isNotEmpty ? EventModel.fromMap(maps.first) : null;
//     } catch (e) {
//       throw Exception('Error fetching event by ID: ${e.toString()}');
//     }
//   }
//
//   // Batch operations method
//   Future<void> batchEvents(List<EventModel> events) async {
//     try {
//       final batch = database.batch();
//
//       for (var event in events) {
//         batch.insert(
//             'events',
//             event.toMap(),
//             conflictAlgorithm: ConflictAlgorithm.replace
//         );
//       }
//
//       await batch.commit(noResult: true);
//     } catch (e) {
//       throw Exception('Batch event insertion failed: ${e.toString()}');
//     }
//   }
//
//   // Advanced filtering method
//   Future<List<EventModel>> filterEvents({
//     DateTime? startDate,
//     DateTime? endDate,
//     String? status,
//     int? userId,
//     String? sortBy,
//     bool ascending = true,
//   }) async {
//     try {
//       // Build dynamic where clause
//       List<String> whereConditions = [];
//       List<dynamic> whereArgs = [];
//
//       if (startDate != null) {
//         whereConditions.add('date >= ?');
//         whereArgs.add(startDate.toIso8601String());
//       }
//
//       if (endDate != null) {
//         whereConditions.add('date <= ?');
//         whereArgs.add(endDate.toIso8601String());
//       }
//
//       if (status != null) {
//         whereConditions.add('status = ?');
//         whereArgs.add(status);
//       }
//
//       if (userId != null) {
//         whereConditions.add('userId = ?');
//         whereArgs.add(userId);
//       }
//
//       final List<Map<String, dynamic>> maps = await database.query(
//         'events',
//         where: whereConditions.isNotEmpty ? whereConditions.join(' AND ') : null,
//         whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
//         orderBy: sortBy != null
//             ? '$sortBy ${ascending ? 'ASC' : 'DESC'}'
//             : null,
//       );
//
//       return maps.map((map) => EventModel.fromMap(map)).toList();
//     } catch (e) {
//       throw Exception('Advanced event filtering failed: ${e.toString()}');
//     }
//   }
// }
//
