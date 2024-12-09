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

// Domain entities are already imported in the model files
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

  RepositoryImpl._(
      this._localEventDataSource,
      this._localFriendDataSource,
      this._localGiftDataSource,
      this._localUserDataSource,
      this._remoteDatabaseHelper,
      );

  static Future<RepositoryImpl> create() async {
    final eventDataSource = await DatabaseHelper.instance.eventDataSource;
    final friendDataSource = await DatabaseHelper.instance.friendDataSource;
    final giftDataSource = await DatabaseHelper.instance.giftDataSource;
    final userDataSource = await DatabaseHelper.instance.userDataSource;
    final remoteDatabaseHelper = RealTimeDatabaseHelper.instance;

    return RepositoryImpl._(
      eventDataSource,
      friendDataSource,
      giftDataSource,
      userDataSource,
      remoteDatabaseHelper,
    );
  }

  // Event Methods
  @override
  Future<List<Event>> getEvents() async {
    try {
      // Fetch from remote database
      final eventModels = await _remoteDatabaseHelper.fetchAllEvents();

      // Sync with local database and convert to entities
      final events = eventModels.map((model) {
        // Insert into local database
        _localEventDataSource.insertEvent(model);
        // Convert to entity
        return model.toEntity();
      }).toList();

      return events;
    } catch (e) {
      // Fallback to local database
      final localEventModels = await _localEventDataSource.getEvents();
      return localEventModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<void> createEvent(Event event) async {
    // Convert entity to model using factory constructor
    final eventModel = EventModel.fromEntity(event);
    await _remoteDatabaseHelper.createEvent(eventModel);
    await _localEventDataSource.insertEvent(eventModel);
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

  // Friend Methods
  @override
  Future<List<Friend>> getFriends(String userId) async {
    try {
      final friendModels = await _remoteDatabaseHelper.fetchAllFriends(userId);

      final friends = friendModels.map((model) {
        _localFriendDataSource.insertFriend(model);
        return model.toEntity();
      }).toList();

      return friends;
    } catch (e) {
      final localFriendModels = await _localFriendDataSource.getFriends();
      return localFriendModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<void> createFriend(Friend friend) async {
    final friendModel = FriendModel.fromEntity(friend);
    await _remoteDatabaseHelper.createFriend(friendModel);
    await _localFriendDataSource.insertFriend(friendModel);
  }

  @override
  Future<void> deleteFriend(String userId, String friendId) async {
    await _remoteDatabaseHelper.deleteFriend(userId, friendId);
    await _localFriendDataSource.deleteFriend(friendId);
  }

  // Gift Methods
  @override
  Future<List<Gift>> getGifts(String eventId) async {
    try {
      final giftModels = await _remoteDatabaseHelper.fetchAllGifts();

      final gifts = giftModels
          .where((gift) => gift.eventId == eventId)
          .map((model) {
        _localGiftDataSource.insertGift(model);
        return model.toEntity();
      })
          .toList();

      return gifts;
    } catch (e) {
      final localGiftModels = await _localGiftDataSource.getGifts(eventId);
      return localGiftModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<void> createGift(Gift gift) async {
    final giftModel = GiftModel.fromEntity(gift);
    await _remoteDatabaseHelper.createGift(giftModel);
    await _localGiftDataSource.insertGift(giftModel);
  }

  @override
  Future<void> updateGift(Gift gift) async {
    final giftModel = GiftModel.fromEntity(gift);
    await _remoteDatabaseHelper.updateGift(gift.id, giftModel);
    await _localGiftDataSource.updateGift(giftModel);
  }

  @override
  Future<void> deleteGift(String id) async {
    await _remoteDatabaseHelper.deleteGift(id);
    await _localGiftDataSource.deleteGift(id);
  }

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