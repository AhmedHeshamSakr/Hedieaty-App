
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
  Future<EventModel> createEvent(EventModel event) async {
   return await eventDataSource.createEvent(event);
  }

  Future<EventModel?> getEventById(String id) async {
    return await eventDataSource.getEventById(id);
  }

  Future<List<EventModel>> fetchAllEvents() async {
    return await eventDataSource.fetchAllEvents();
  }

  Future<List<EventModel>> getEventsByUserId(String userId) async {
    return await eventDataSource.getEventsByUserId(userId);
  }

  Future<int> upcomingEvents(String userId) async {
    return await eventDataSource.countUpcomingEventsForUser(userId);
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

  Future<List<FriendModel>> fetchAllFriends() async {
    return await friendDataSource.fetchAllFriends();
  }

  Future<List<FriendModel>> getFriendByUserId(String userId) async {
    return await friendDataSource.fetchFriendsByUserId(userId);
  }


  Future<FriendModel?> getFriendById(String userId, String friendId) async {
   return await friendDataSource.getFriendById(userId, friendId);
  }

  Future<bool> isFriendExistsRemotely({required String userId, required String friendId}) async {
    return await friendDataSource.isFriendExistsRemotely(userId: userId, friendId: friendId);
  }


  Future<List<FriendModel>> getFriendsByUserId(String userId) async {
    return await friendDataSource.getFriendsByUserId(userId);
  }



  Future<void> deleteFriend(String userId, String friendId) async {
    await friendDataSource.deleteFriend(userId, friendId);

  }

/////////////////////////////////////////////////////////////////
  Future<GiftModel> createGift(GiftModel gift) async {
    return await giftDataSource.createGift(gift);
  }

  Future<void> pledgeGift(String giftId, String gifterId) async {
    await giftDataSource.pledgeGift(giftId, gifterId);
  }

  Future<void> unpledgeGift(String giftId,) async {
    await giftDataSource.unpledgeGift(giftId);
  }

  Future<GiftModel?> getGiftById(String id) async {
    return await giftDataSource.getGiftById(id);
  }

  Future<List<GiftModel>> fetchAllGifts(String eventId ) async {
    return await giftDataSource.fetchGiftsByEvent(eventId);
  }

  Future<void> updateGift(GiftModel gift) async {
    await giftDataSource.updateGift(gift);
  }

  Future<void> deleteGift(String id) async {
    await giftDataSource.deleteGift(id);
  }
  Future<List<GiftModel>> fetchGiftsByUserId(String userId) async {
    return await giftDataSource.fetchGiftsByUserId(userId);
  }

  Future<List<GiftModel>> fetchGiftsPledgedByUser(String gifterId) async {
     return await giftDataSource.fetchGiftsPledgedByUser(gifterId);
  }


    Future<List<GiftModel>> fetchGiftsByEventAndStatus(String eventId, String status) async {
    return await giftDataSource.fetchGiftsByEventAndStatus(eventId, status);
  }

/////////////////////////////////////////////////////////////////
  Future<void> createUser(UserModel user) async {
    await userDataSource.createUser(user);
  }

  Future<UserModel?> getUserById(String id) async {
    return await userDataSource.getUserById(id);
  }
  Future<UserModel?> getUserByEmail(String email) async {
    return await userDataSource.getUserByEmail(email);
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
