import '../../data/local/models/event_model.dart';
import '../../data/local/models/gift_model.dart';
import '/data/local/models/user_model.dart';

abstract class UserRepository {
  /// Fetches a user profile by ID.
  Future<UserModel?> getUserProfile(String userId);

  /// Updates a user profile.
  Future<void> updateUserProfile(UserModel user);

  /// Signs in a user with email and password.
  Future<void> signIn(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();

  Future<List<EventModel>> getUserCreatedEvents(int userId);

  Future<List<GiftModel>> getUserPledgedGifts(int userId);

  Future<void> pledgeGift(int giftId, int userId);
}