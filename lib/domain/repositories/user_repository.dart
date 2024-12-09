import '../../data/models/event_model.dart';
import '../../data/models/gift_model.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  /// Fetches a user profile by ID.
  Future<UserModel?> getUserProfile(int userId);

  /// Updates a user profile.
  Future<void> updateUserProfile(UserModel user);

  /// Signs in a user with email and password.
  Future<void> signIn(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();

  /// Fetches events created by the user.
  Future<List<EventModel>> getUserCreatedEvents(int userId);

  /// Fetches gifts pledged by the user.
  Future<List<GiftModel>> getUserPledgedGifts(int userId);

  /// Pledges a gift by the user.
  Future<void> pledgeGift(int giftId, int userId);
}
