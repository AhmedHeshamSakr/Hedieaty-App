import '../../domain/repositories/gift_repository.dart';
import '../local/datasources/sqlite_gift_datasource.dart';
import '../local/models/gift_model.dart';

class GiftRepositoryImpl implements GiftRepository{
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
  getGiftById(int giftId) {
    // TODO: implement getGiftById
    throw UnimplementedError();
  }
}
