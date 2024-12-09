import 'package:firebase_database/firebase_database.dart';
import '../models/event_model.dart';
import '../models/friend_model.dart';
import '../models/gift_model.dart';
import '../models/user_model.dart';
import 'datasources/firebase_event_datasource.dart';
import 'datasources/firebase_friend_datasource.dart';
import 'datasources/firebase_gift_datasource.dart';
import 'datasources/firebase_user_datasource.dart';

class RealTimeDatabaseHelper {
  // Singleton pattern
  static final RealTimeDatabaseHelper instance = RealTimeDatabaseHelper._init();

  // Firebase Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Instances of data sources
  final EventRemoteDataSource eventDataSource;
  final FriendRemoteDataSource friendDataSource;
  final GiftRemoteDataSource giftDataSource;
  final UserRemoteDataSource userDataSource;

  RealTimeDatabaseHelper._init()
      : eventDataSource = EventRemoteDataSource(),
        friendDataSource = FriendRemoteDataSource(),
        giftDataSource = GiftRemoteDataSource(),
        userDataSource = UserRemoteDataSource();

  // Example of a method using data sources
  Future<void> createEvent(EventModel event) async {
    await eventDataSource.createEvent(event);
  }

  Future<EventModel?> getEventById(String id) async {
    return await eventDataSource.getEventById(id);
  }

  Future<List<EventModel>> fetchAllEvents() async {
    return await eventDataSource.fetchAllEvents();
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await eventDataSource.updateEvent(id, event);
  }

  Future<void> deleteEvent(String id) async {
    await eventDataSource.deleteEvent(id);
  }
/////////////////////////////////////////////////////////////////

  Future<void> createFriend(FriendModel friend) async {
     await friendDataSource.createFriend(friend);
  }

  Future<List<FriendModel>> fetchAllFriends(String userId) async {
    return await friendDataSource.fetchAllFriends(userId);
  }

  Future<FriendModel?> getFriendById(String userId, String friendId) async {
   return await friendDataSource.getFriendById(userId, friendId);
  }

  Future<void> deleteFriend(String userId, String friendId) async {
    await friendDataSource.deleteFriend(userId, friendId);

  }

/////////////////////////////////////////////////////////////////
  Future<void> createGift(GiftModel gift) async {
    await giftDataSource.createGift(gift);
  }

  Future<GiftModel?> getGiftById(String id) async {
    return await giftDataSource.getGiftById(id);
  }

  Future<List<GiftModel>> fetchAllGifts() async {
    return await giftDataSource.fetchAllGifts();
  }

  Future<void> updateGift(String id, GiftModel gift) async {
    await giftDataSource.updateGift(id, gift);
  }

  Future<void> deleteGift(String id) async {
    await giftDataSource.deleteGift(id);
  }

/////////////////////////////////////////////////////////////////
  Future<void> createUser(UserModel user) async {
    await userDataSource.createUser(user);
  }

  Future<UserModel?> getUserById(String id) async {
    return await userDataSource.getUserById(id);
  }

  Future<List<UserModel>> fetchAllUsers() async {
    return await userDataSource.fetchAllUsers();
  }

  Future<void> updateUser(String id, UserModel user) async {
    await userDataSource.updateUser(id, user);
  }

  Future<void> deleteUser(String id) async {
    await userDataSource.deleteUser(id);
  }

}
