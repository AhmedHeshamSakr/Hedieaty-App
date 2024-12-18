import 'dart:async';

import '../entities/event.dart';
import '../entities/friend.dart';
import '../entities/gift.dart';
import '../entities/user.dart';

abstract class Repository {
  // Event Methods
  Future<List<Event>> getEvents();
  Future<List<Event>> getEventsByUserId(String userId);
    Future<void> createEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);

  // Friend Methods
  Future<List<Friend>> getFriends();
  Future<void> createFriend(Friend friend);
  Future<void> deleteFriend(String friendId);
  Future<bool> isFriendExists({required String userId, required String friendId});
  void syncFriendsWithRemote(String currentUserId);
  Future<void> syncDatabases(String currentUserId);


    // Gift Methods
  Future<List<Gift>> getGifts(String eventId);
  Future<List<Gift>> getGiftsByUserId(String userId);
  Future<void> pledgeGift(String giftId , String gifterId);
  Future<void> unpledgeGift(String giftId);
  Future<String?> getStatus(String giftId);
  Future<void> setStatus(String giftId, String newStatus);
  Future<List<Gift>> getGiftsByEventAndStatus(String eventId, String status);
  Future<Gift?> getGiftsById(String id);
  Future<void> createGift(Gift gift);
  Future<void> updateGift(Gift gift);
  Future<void> deleteGift(String id);

  // User Methods
  Future<User?> getUser(String id);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<User?> getUserByEmail(String email);


  // Future<void> sendFriendRequest(FriendRequest request);
  // Future<void> acceptFriendRequest(String requestId);
  // Future<void> rejectFriendRequest(String requestId);
  // Future<List<FriendRequest>> fetchFriendRequests(String userId);
  //
}