import 'package:firebase_database/firebase_database.dart';
import '../models/event_dto.dart';

class FirebaseEventDataSource {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> addEvent(EventDTO eventDTO) async {
    final eventRef = _database.child('events').push();
    await eventRef.set(eventDTO.toMap());
  }

  Future<void> updateEvent(String eventId, EventDTO eventDTO) async {
    final eventRef = _database.child('events').child(eventId);
    await eventRef.update(eventDTO.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    final eventRef = _database.child('events').child(eventId);
    await eventRef.remove();
  }

  Future<List<EventDTO>> getAllEvents() async {
    final snapshot = await _database.child('events').get();
    if (snapshot.exists) {
      final eventsMap = snapshot.value as Map<dynamic, dynamic>;
      return eventsMap.entries
          .map((entry) => EventDTO.fromMap(entry.value)..id = entry.key)
          .toList();
    }
    return [];
  }

  Future<List<EventDTO>> getEventsByUserId(String userId) async {
    final snapshot = await _database
        .child('events')
        .orderByChild('userId')
        .equalTo(userId)
        .get();

    if (snapshot.exists) {
      final eventsMap = snapshot.value as Map<dynamic, dynamic>;
      return eventsMap.entries
          .map((entry) => EventDTO.fromMap(entry.value)..id = entry.key)
          .toList();
    }
    return [];
  }
}
