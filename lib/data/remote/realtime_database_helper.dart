import 'package:firebase_database/firebase_database.dart';
import 'models/event_dto.dart';
import 'models/friend_dto.dart';
import 'models/gift_dto.dart';
import 'models/user_dto.dart'; // Import your DTO classes

class RealTimeDatabaseHelper {
  // Singleton pattern for database helper
  static final RealTimeDatabaseHelper instance = RealTimeDatabaseHelper._init();
  // factory DatabaseHelper() => _instance;
  // DatabaseHelper._internal();

  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  RealTimeDatabaseHelper._init();

  // Events Collection Methods
  Future<void> createEvent(EventDTO event) async {
    try {
      // Generate a unique ID if not provided
      final eventRef = _database.child('events').push();
      event.id = eventRef.key!;

      await eventRef.set(event.toMap());
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }

  Future<List<EventDTO>> fetchEvents() async {
    try {
      final snapshot = await _database.child('events').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> eventsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
        return eventsMap.entries.map((entry) {
          var eventData = Map<String, dynamic>.from(entry.value);
          eventData['id'] = entry.key;
          return EventDTO.fromMap(eventData);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  // Similar methods for other DTOs (Friends, Gifts, Users)
  Future<void> createFriend(FriendDTO friend) async {
    try {
      await _database.child('friends').push().set(friend.toMap());
    } catch (e) {
      print('Error creating friend connection: $e');
      rethrow;
    }
  }

  Future<void> createGift(GiftDTO gift) async {
    try {
      final giftRef = _database.child('gifts').push();
      gift.id = giftRef.key!;

      await giftRef.set(gift.toMap());
    } catch (e) {
      print('Error creating gift: $e');
      rethrow;
    }
  }

  Future<void> createUser(UserDTO user) async {
    try {
      await _database.child('users').child(user.id as String).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

// Add methods for updating and deleting records
}