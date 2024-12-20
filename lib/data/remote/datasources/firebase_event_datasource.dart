import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/event_model.dart';


class EventRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("events");

  Future<EventModel> createEvent(EventModel event) async {
    // Ensure current user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    // Create a new event reference with auto-generated ID
    final newEventRef = _dbRef.push();
    final String firebaseEventId = newEventRef.key!;
    final EventModel eventToCreate = EventModel(
      id: firebaseEventId,
      name: event.name,
      date: event.date,
      location: event.location,
      description: event.description,
      userId: currentUser.uid, // Always set to current user
      status: event.status, // Default status if not provided
    );
    await newEventRef.set(eventToCreate.toJson());
    return eventToCreate;
  }

  Future<List<EventModel>> fetchAllEvents() async {
    // Ensure current user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    // Query events specific to the current user
    final snapshot = await _dbRef.orderByChild('userId').equalTo(currentUser.uid).get();
    if (snapshot.exists) {
      final events = Map<String, dynamic>.from(snapshot.value as Map);
      return events.values.map((json) => EventModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }


  Future<List<EventModel>> getEventsByUserId(String userId) async {
    final snapshot = await _dbRef.orderByChild('userId').equalTo(userId).get();
    if (snapshot.exists) {
      final events = Map<String, dynamic>.from(snapshot.value as Map);
      return events.values
          .map((json) => EventModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }
    return [];
  }

  Future<int> countUpcomingEventsForUser(String userId) async {
    final snapshot = await _dbRef.orderByChild('userId').equalTo(userId).get();
    if (snapshot.exists) {
      final events = Map<String, dynamic>.from(snapshot.value as Map);
      final upcomingEventsCount = events.values
          .map((json) => EventModel.fromJson(Map<String, dynamic>.from(json)))
          .where((event) => event.status == 'upcoming') // Filter by status 'upcoming'
          .length;
      return upcomingEventsCount;
    }
    return 0;
  }


  Future<EventModel?> getEventById(String id) async {
    final snapshot = await _dbRef.child(id).get();
    if (snapshot.exists) {
      return EventModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await _dbRef.child(id).update(event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    await _dbRef.child(id).remove();
  }
}
