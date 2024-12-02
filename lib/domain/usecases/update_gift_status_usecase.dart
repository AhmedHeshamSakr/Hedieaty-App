import '../repositories/gift_repository.dart';
class UpdateGiftStatusUseCase {
  final GiftRepository giftRepository;

  UpdateGiftStatusUseCase(this.giftRepository);

  Future<void> execute(int giftId, String status) async {
    try {
      final gift = await giftRepository.getGiftById(giftId);
      if (gift != null) {
        final updatedGift = gift.copyWith(status: status);
        await giftRepository.updateGift(updatedGift);
      } else {
        throw Exception('Gift not found');
      }
    } catch (e) {
      throw Exception('Error updating gift status: ${e.toString()}');
    }
  }
}