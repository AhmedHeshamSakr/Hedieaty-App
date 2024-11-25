import '../entities/gift.dart';
import '../repositories/gift_repository.dart';

class PledgeGiftUseCase {
  final GiftRepository giftRepository;

  PledgeGiftUseCase(this.giftRepository);

  Future<void> call(int giftId) async {
    final gift = await giftRepository.getGiftById(giftId);
    if (gift != null && gift.status != "pledged") {
      final updatedGift = gift.copyWith(status: "pledged");
      await giftRepository.updateGift(updatedGift);
    }
  }
}
