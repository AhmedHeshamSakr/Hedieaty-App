import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/repositories/main_repository.dart';
import '../local/database_helper.dart';
import '../local/datasources/sqlite_event_datasource.dart';
import '../local/datasources/sqlite_friend_datasource.dart';
import '../local/datasources/sqlite_gift_datasource.dart';
import '../local/datasources/sqlite_user_datasource.dart';
import '../models/event_model.dart';
import '../models/friend_model.dart';
import '../models/gift_model.dart';
import '../models/user_model.dart';
import '../remote/realtime_database_helper.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/friend.dart';
import '../../domain/entities/gift.dart';
import '../../domain/entities/user.dart';


class RepositoryImpl implements Repository {
  final SQLiteEventDataSource _localEventDataSource;
  final SQLiteFriendDataSource _localFriendDataSource;
  final SQLiteGiftDataSource _localGiftDataSource;
  final SqliteUserDatasource _localUserDataSource;
  final RealTimeDatabaseHelper _remoteDatabaseHelper;

  RepositoryImpl(this._localEventDataSource,
      this._localFriendDataSource,
      this._localGiftDataSource,
      this._localUserDataSource,
      this._remoteDatabaseHelper,);

  static Future<RepositoryImpl> create() async {
    final eventDataSource = await DatabaseHelper.instance.eventDataSource;
    final friendDataSource = await DatabaseHelper.instance.friendDataSource;
    final giftDataSource = await DatabaseHelper.instance.giftDataSource;
    final userDataSource = await DatabaseHelper.instance.userDataSource;
    final remoteDatabaseHelper = RealTimeDatabaseHelper.instance;

    return RepositoryImpl(
      eventDataSource,
      friendDataSource,
      giftDataSource,
      userDataSource,
      remoteDatabaseHelper,
    );
  }

  @override
  Future<void> syncDatabases(String currentUserId) async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    // Fetch remote friends
    final remoteFriends = await _remoteDatabaseHelper.fetchAllFriends();

    // Fetch local friends
    final localFriends = await _localFriendDataSource.getFriends();

    // Add missing remote friends to local
    for (final friend in remoteFriends) {
      if (!localFriends.any((f) => f.friendId == friend.friendId)) {
        await _localFriendDataSource.insertFriend(friend);
      }
    }

    // Remove extra local friends not in remote
    for (final friend in localFriends) {
      if (!remoteFriends.any((f) => f.friendId == friend.friendId)) {
        await _localFriendDataSource.deleteFriend(friend.friendId);
      }
    }
  }

  @override
  void syncFriendsWithRemote(String currentUserId) {
    final friendsRef = FirebaseDatabase.instance.ref('friends/$currentUserId');

    // Listen for added friends
    friendsRef.onChildAdded.listen((event) {
      final friendId = event.snapshot.key;
      if (friendId != null) {
        // Add the friend to the local database
        final friend = Friend(userId: currentUserId, friendId: friendId);
        _localFriendDataSource.insertFriend(FriendModel.fromEntity(friend));
      }
    });
    // Listen for removed friends
    friendsRef.onChildRemoved.listen((event) {
      final friendId = event.snapshot.key;
      if (friendId != null) {
        // Remove the friend from the local database
        _localFriendDataSource.deleteFriend(friendId);
      }
    });
  }


  // Event Methods
  @override
  Future<List<Event>> getEvents() async {
    try {
      final eventModels = await _remoteDatabaseHelper.fetchAllEvents();
      final events = eventModels.map((model) {
        _localEventDataSource.insertEvent(model);
        return model.toEntity();
      }).toList();
      return events;
    } catch (e) {
      final localEventModels = await _localEventDataSource.getEvents();
      return localEventModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<Event>> getEventsByUserId(String userId) async {
    try {
      // Fetch events remotely
      final remoteEventModels = await _remoteDatabaseHelper.getEventsByUserId(
          userId);
      final events = remoteEventModels.map((model) {
        _localEventDataSource.insertEvent(model);
        return model.toEntity();
      }).toList();
      return events;
    } catch (e) {
      // If remote fetch fails, fallback to local database
      final localEventModels = await _localEventDataSource.getEventsByUserId(
          userId);
      return localEventModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<void> createEvent(Event event) async {
    final initialEventModel = EventModel.fromEntity(event);
    final createdEventModel = await _remoteDatabaseHelper.createEvent(
        initialEventModel);
    await _localEventDataSource.insertEvent(createdEventModel);
  }

  @override
  Future<void> updateEvent(Event event) async {
    final eventModel = EventModel.fromEntity(event);
    await _remoteDatabaseHelper.updateEvent(event.id, eventModel);
    await _localEventDataSource.updateEvent(eventModel);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _remoteDatabaseHelper.deleteEvent(id);
    await _localEventDataSource.deleteEvent(id);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////
  // Friend Methods
  @override
  Future<List<Friend>> getFriends() async {
    try {
      final friendModels = await _remoteDatabaseHelper.fetchAllFriends();

      // Log the number of friends retrieved
      print('Retrieved ${friendModels.length} friends from remote');

      // Insert each friend into the local database
      for (final model in friendModels) {
        await _localFriendDataSource.insertFriend(model);
      }

      // Convert models to entities
      final friends = friendModels.map((model) => model.toEntity()).toList();

      return friends;
    } catch (e) {
      print('Error in getFriends: $e');

      // Fallback to local database
      try {
        final localFriendModels = await _localFriendDataSource.getFriends();
        return localFriendModels.map((model) => model.toEntity()).toList();
      } catch (localError) {
        print('Error fetching local friends: $localError');
        return [];
      }
    }
  }

  @override
  Future<void> createFriend(Friend friend) async {
    final friendModel = FriendModel.fromEntity(friend);
    // Add friend relationship remotely
    await _remoteDatabaseHelper.createFriend(friendModel);
    // Add friend relationship locally
    await _localFriendDataSource.insertFriend(friendModel);
  }

  @override
  Future<bool> isFriendExists(
      {required String userId, required String friendId}) async {
    try {
      // Check remotely first
      final existsRemotely = await _remoteDatabaseHelper.isFriendExistsRemotely(
          userId: userId, friendId: friendId);
      if (existsRemotely) {
        return true;
      }
      // If not found remotely, check locally
      final existsLocally = await _localFriendDataSource.isFriendExistsLocally(
          userId: userId, friendId: friendId);
      return existsLocally;
    } catch (e) {
      // Log the error and handle any exceptions
      debugPrint('Error checking friend existence: $e');
      return false;
    }
  }


  @override
  Future<void> deleteFriend(String friendId) async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    // Remove relationship remotely
    await _remoteDatabaseHelper.deleteFriend(currentUser.uid, friendId);
    // Remove reciprocal relationship remotely
    await _remoteDatabaseHelper.deleteFriend(friendId, currentUser.uid);
    // Remove relationship locally
    await _localFriendDataSource.deleteFriend(friendId);
  }

  // Gift Methods
//////////////////////////////////////////////////////////////////////////////////////////////////


  @override
  Future<List<Gift>> getGifts(String eventId) async {
    try {
      // First, fetch from remote
      final remoteGiftModels = await _remoteDatabaseHelper.fetchAllGifts(
          eventId);

      if (remoteGiftModels.isNotEmpty) {
        await _localGiftDataSource.clearGiftsByEvent(eventId);
        for (var giftModel in remoteGiftModels) {
          await _localGiftDataSource.insertGift(giftModel);
        }
        return remoteGiftModels.map((model) => model.toEntity()).toList();
      }
      final localGiftModels = await _localGiftDataSource.getGifts(eventId);
      return localGiftModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint('Sync error: $e');
      final localGiftModels = await _localGiftDataSource.getGifts(eventId);
      return localGiftModels.map((model) => model.toEntity()).toList();
    }
  }



  // 1. Get the status of a specific gift
  @override
  Future<String?> getStatus(String giftId) async {
    try {
      final remoteGift = await _remoteDatabaseHelper.getGiftById(giftId);
      if (remoteGift != null) {
        return remoteGift.status;
      }
      final localGift = await _localGiftDataSource.getGiftsByUserId(giftId);
      return localGift.isNotEmpty ? localGift.first.status : null;
    } catch (e) {
      debugPrint('Error getting gift status: $e');
      return null;
    }
  }

  @override
  Future<void> setStatus(String giftId, String newStatus) async {
    try {
      // Fetch the gift from the remote source
      final gift = await _remoteDatabaseHelper.getGiftById(giftId);
      if (gift != null) {
        // Update status using GiftModel
        final updatedGiftModel = GiftModel.fromEntity(gift.copyWith(status: newStatus));
        // Update status in the remote source
        await _remoteDatabaseHelper.updateGift(updatedGiftModel);
        // Update status in the local source
        await _localGiftDataSource.updateGift(updatedGiftModel);
      } else {
        throw Exception('Gift not found.');
      }
    } catch (e) {
      debugPrint('Error updating gift status: $e');
      throw Exception('Failed to update status');
    }
  }


  // 3. Pledge a gift from a friend's gift list
  @override
  // Pledge a gift and sync between local and remote
  Future<void> pledgeGift(String giftId, String gifterId) async {
    try {
      // Update remote
      await _remoteDatabaseHelper.pledgeGift(giftId, gifterId);
      // Update local
      await _localGiftDataSource.pledgeGift(giftId, gifterId);
    } catch (e) {
      throw Exception('Failed to pledge gift: $e');
    }
  }

  // Unpledge a gift and sync between local and remote
  Future<void> unpledgeGift(String giftId) async {
    try {
      await _remoteDatabaseHelper.unpledgeGift(giftId);
      await _localGiftDataSource.unpledgeGift(giftId);
    } catch (e) {
      throw Exception('Failed to unpledge gift: $e');
    }
  }




  // Other methods similar to before, with added sync logic
  @override
  Future<void> createGift(Gift gift) async {
    try {
      final giftModel = GiftModel.fromEntity(gift);
      final createdGiftModel = await _remoteDatabaseHelper.createGift(
          giftModel);
      await _localGiftDataSource.insertGift(createdGiftModel);
    } catch (e) {
      throw Exception('Failed to create and sync gift: ${e.toString()}');
    }
  }

  @override
  Future<void> updateGift(Gift gift) async {
    try {
      // Convert gift to model for database operations
      final giftModel = GiftModel.fromEntity(gift);
      // Perform concurrent updates
      await Future.wait([
        _localGiftDataSource.updateGift(giftModel),
        _remoteDatabaseHelper.updateGift(giftModel)
      ]);
    } catch (e) {
      // Log the error or handle specific error scenarios
      throw Exception('Failed to update gift across data sources: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGift(String id) async {
    try {
      await _remoteDatabaseHelper.deleteGift(id);
      await _localGiftDataSource.deleteGift(id);
    } catch (e) {
      throw Exception('Failed to delete gift: ${e.toString()}');
    }
  }

  @override
  Future<Gift?> getGiftsById(String id) async {
    try {
      final giftModle = await _remoteDatabaseHelper.getGiftById(id);
      if (giftModle != null) {
        await _localGiftDataSource.insertGift(giftModle);
        return giftModle.toEntity();
      }
      return null;
    } catch (e) {
      final localUserModel = await _localGiftDataSource.getGiftById(id);
      return localUserModel?.toEntity();
    }
  }

  @override
  Future<List<Gift>> getGiftsByUserId(String userId) async {
    try {
      final giftModels = await _remoteDatabaseHelper.fetchGiftsByUserId(userId);
      final gifts = giftModels.map((model) {
        _localGiftDataSource.insertGift(model);
        return model.toEntity();
      }).toList();
      return gifts;
    } catch (e) {
      // Fallback to local database
      final localGiftModels = await _localGiftDataSource.getGiftsByUserId(
          userId);
      return localGiftModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<Gift>> getGiftsByEventAndStatus(String eventId,
      String status) async {
    try {
      // Fetch gifts for a specific event and status from remote source
      final giftModels = await _remoteDatabaseHelper.fetchGiftsByEventAndStatus(
          eventId, status);

      final gifts = giftModels.map((model) {
        // Sync fetched gifts to local database
        _localGiftDataSource.insertGift(model);
        return model.toEntity();
      }).toList();
      return gifts;
    } catch (e) {
      // Fallback to local database
      final localGiftModels = await _localGiftDataSource
          .getGiftsByEventAndStatus(eventId, status);
      return localGiftModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
// New method for pledging a gift

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // User Methods
  @override
  Future<User?> getUser(String id) async {
    try {
      final userModel = await _remoteDatabaseHelper.getUserById(id);
      if (userModel != null) {
        await _localUserDataSource.insertUser(userModel);
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      final localUserModel = await _localUserDataSource.getUser(id);
      return localUserModel?.toEntity();
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final userModel = await _remoteDatabaseHelper.getUserByEmail(email);
      if (userModel != null) {
        await _localUserDataSource.insertUser(userModel);
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      final localUserModel = await _localUserDataSource.getUserByEmail(email);
      return localUserModel?.toEntity();
    }
  }

  @override
  Future<void> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await _remoteDatabaseHelper.createUser(userModel);
    await _localUserDataSource.insertUser(userModel);
  }

  @override
  Future<void> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await _remoteDatabaseHelper.updateUser(user.id, userModel);
    await _localUserDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _remoteDatabaseHelper.deleteUser(id);
    await _localUserDataSource.deleteUser(id);
  }
}





// Future<void> toggleGiftStatus(String giftId, String newStatus) async {
//   try {
//     // Get the current user to verify they are the gifter
//     final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       throw Exception('No authenticated user');
//     }
//     // Toggle status in remote database
//     await _remoteDatabaseHelper.toggleGiftStatus(giftId, newStatus);
//     // Toggle status in local database
//     await _localGiftDataSource.toggleGiftStatus(giftId, newStatus,currentUser.uid);
//   } catch (e) {
//     throw Exception('Failed to toggle gift status: ${e.toString()}');
//   }
// }



// Future<GiftModel?> pledgeGift(String giftId) async {
//   try {
//     // First, pledge the gift in the remote database
//     final remoteGift = await  _remoteDatabaseHelper.pledgeGift(giftId);
//     if (remoteGift != null) {
//       // If successful in remote, update local database
//       final currentUser =firebase_auth.FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         throw Exception('No authenticated user');
//       }
//       await _localGiftDataSource.pledgeGift(giftId, currentUser.uid);
//       return remoteGift;
//     }
//     return null;
//   } catch (e) {
//     debugPrint('Error pledging gift: $e');
//     rethrow;
//   }
//

