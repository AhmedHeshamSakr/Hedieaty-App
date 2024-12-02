import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_dto.dart';

class FirestoreEventDataSource {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(EventDTO eventDTO) async {
    await _eventsCollection.add(eventDTO.toMap());
  }

  Future<void> updateEvent(String eventId, EventDTO eventDTO) async {
    await _eventsCollection.doc(eventId).update(eventDTO.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  Future<List<EventDTO>> getEventsByUserId(String userId) async {
    final querySnapshot = await _eventsCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => EventDTO.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}
