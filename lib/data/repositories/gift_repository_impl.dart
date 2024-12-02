import '../../domain/repositories/gift_repository.dart';
import '../local/datasources/sqlite_gift_datasource.dart';
import '../local/models/gift_model.dart';

class GiftRepositoryImpl implements GiftRepository {
  final SqliteGiftDatasource localDatasource;

  GiftRepositoryImpl(this.localDatasource);

  @override
  Future<List<GiftModel>> getGiftsByEventId(int eventId) async {
    return await localDatasource.getGiftsByEventId(eventId);
  }

  @override
  Future<void> addGift(GiftModel gift) async {
    await localDatasource.insertGift(gift);
  }

  @override
  Future<void> updateGift(GiftModel gift) async {
    await localDatasource.updateGift(gift);
  }

  @override
  Future<void> deleteGift(int giftId) async {
    await localDatasource.deleteGift(giftId);
  }

  @override
  Future<GiftModel?> getGiftById(int giftId) async {
    try {
      final gifts = await localDatasource.getGiftsByEventId(giftId);
      for (var gift in gifts) {
        if (gift.id == giftId) {
          return gift;
        }
      }
      return null; // Return null if no match is found
    } catch (e) {
      throw Exception('Error fetching gift by ID: ${e.toString()}');
    }
  }

  /// New functionality: Pledge a gift
  @override
  Future<void> pledgeGift(int giftId, int userId) async {
    await localDatasource.pledgeGift(giftId, userId);
  }
}