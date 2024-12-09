import 'package:firebase_database/firebase_database.dart';
import '../../models/event_model.dart';


class EventRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("events");

  Future<void> createEvent(EventModel event) async {
    await _dbRef.child(event.id).set(event.toJson());
  }

  Future<EventModel?> getEventById(String id) async {
    final snapshot = await _dbRef.child(id).get();
    if (snapshot.exists) {
      return EventModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<EventModel>> fetchAllEvents() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final events = Map<String, dynamic>.from(snapshot.value as Map);
      return events.values.map((json) => EventModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await _dbRef.child(id).update(event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    await _dbRef.child(id).remove();
  }
}












// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import '../models/event_dto.dart';
//
// class FirebaseEventDataSource {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   /// Adds an event to Firebase Realtime Database and returns the new event's ID
//   ///
//   /// Throws an exception if the event insertion fails
//   Future<String> addEvent(EventDTO eventDTO) async {
//     try {
//       // Create a new child reference with a unique key
//       final eventRef = _database.child('events').push();
//
//       // Set the event data at this reference
//       await eventRef.set(eventDTO.toMap());
//
//       // Return the unique key (ID) of the newly created event
//       return eventRef.key!;
//     } catch (e) {
//       // Log the error and rethrow to allow caller to handle
//       if (kDebugMode) {
//         print('Error adding event to Firebase: $e');
//       }
//       rethrow;
//     }
//   }
//
//   Future<void> updateEvent(String eventId, EventDTO eventDTO) async {
//     try {
//       final eventRef = _database.child('events').child(eventId);
//       await eventRef.update(eventDTO.toMap());
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error updating event in Firebase: $e');
//       }
//       rethrow;
//     }
//   }
//
//   Future<void> deleteEvent(String eventId) async {
//     try {
//       final eventRef = _database.child('events').child(eventId);
//       await eventRef.remove();
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error deleting event from Firebase: $e');
//       }
//       rethrow;
//     }
//   }
//
//   Future<List<EventDTO>> getAllEvents() async {
//     try {
//       final snapshot = await _database.child('events').get();
//       if (snapshot.exists) {
//         // Safely handle the case where snapshot.value might be null
//         final eventsMap = snapshot.value as Map<dynamic, dynamic>?;
//
//         if (eventsMap == null) return [];
//
//         return eventsMap.entries
//             .map((entry) => EventDTO.fromMap(entry.value)..id = entry.key)
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching all events from Firebase: $e');
//       }
//       rethrow;
//     }
//   }
//
//   Future<List<EventDTO>> getEventsByUserId(String userId) async {
//     try {
//       final snapshot = await _database
//           .child('events')
//           .orderByChild('userId')
//           .equalTo(userId)
//           .get();
//
//       if (snapshot.exists) {
//         // Safely handle the case where snapshot.value might be null
//         final eventsMap = snapshot.value as Map<dynamic, dynamic>?;
//
//         if (eventsMap == null) return [];
//
//         return eventsMap.entries
//             .map((entry) => EventDTO.fromMap(entry.value)..id = entry.key)
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching events by user ID from Firebase: $e');
//       }
//       rethrow;
//     }
//   }
// }