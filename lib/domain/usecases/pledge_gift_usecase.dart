import '../repositories/gift_repository.dart';

class PledgeGiftUseCase {
  final GiftRepository giftRepository;

  PledgeGiftUseCase(this.giftRepository);

  Future<void> execute(int giftId, int userId) async {
    try {
      await giftRepository.pledgeGift(giftId, userId);
    } catch (e) {
      throw Exception('Error pledging gift: ${e.toString()}');
    }
  }
}