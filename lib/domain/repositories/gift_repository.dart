
import '../../data/local/models/gift_model.dart';

/// This interface defines the contract for gift-related operations.
/// The implementation of this repository (e.g., GiftRepositoryImpl)
/// will handle the actual logic of interacting with data sources.
abstract class GiftRepository {
  /// Fetches a list of gifts associated with a specific event ID.
  Future<List<GiftModel>> getGiftsByEventId(int eventId);

  /// Adds a new gift to the repository.
  Future<void> addGift(GiftModel gift);

  /// Updates an existing gift in the repository.
  Future<void> updateGift(GiftModel gift);

  /// Deletes a gift from the repository using its ID.
  Future<void> deleteGift(int giftId);

  getGiftById(int giftId) {}
}
