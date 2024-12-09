import 'dart:async';

import '../entities/event.dart';
import '../entities/friend.dart';
import '../entities/gift.dart';
import '../entities/user.dart';

abstract class Repository {
  // Event Methods
  Future<List<Event>> getEvents();
  Future<void> createEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);

  // Friend Methods
  Future<List<Friend>> getFriends(String userId);
  Future<void> createFriend(Friend friend);
  Future<void> deleteFriend(String userId, String friendId);

  // Gift Methods
  Future<List<Gift>> getGifts(String eventId);
  Future<void> createGift(Gift gift);
  Future<void> updateGift(Gift gift);
  Future<void> deleteGift(String id);

  // User Methods
  Future<User?> getUser(String id);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}