import '../repositories/gift_repository.dart';
import '../repositories/user_repository.dart';

class SyncGiftListUseCase {
  final GiftRepository giftRepository;
  final UserRepository userRepository;

  SyncGiftListUseCase(this.giftRepository, this.userRepository);

  Future<void> execute(int userId) async {
    try {
      // Sync pledged gifts from user repository to gift repository (local + remote logic)
      final pledgedGifts = await userRepository.getUserPledgedGifts(userId);
      for (final gift in pledgedGifts) {
        await giftRepository.updateGift(gift);
      }
    } catch (e) {
      throw Exception('Error syncing gift list: ${e.toString()}');
    }
  }
}