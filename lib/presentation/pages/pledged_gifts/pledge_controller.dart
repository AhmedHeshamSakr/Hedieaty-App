import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/gift.dart';
import '../../../domain/repositories/main_repository.dart';

// Controller for Pledged Gifts
class PledgedGiftsController with ChangeNotifier {
  final Repository repository;
  PledgedGiftsController(this.repository);
  List<Gift> gifts = [];
  bool isLoading = true;


  // Fetch all gifts for a specific event
  Future<void> loadGifts(String gifterId) async {
    isLoading = true;
    notifyListeners();
    try {
      gifts = await repository.fetchGiftsPledgedByUser(gifterId);
    } catch (e) {
      debugPrint("Failed to load gifts: $e");
      gifts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // **Pledge a gift**
  Future<void> pledgeGift(String giftId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }
      await repository.pledgeGift(giftId, currentUser.uid);
      final index = gifts.indexWhere((gift) => gift.id == giftId);
      if (index != -1) {
        gifts[index] = gifts[index].copyWith(
          gifterId: currentUser.uid,
          status: 'Pledged',
        );
        notifyListeners();
      }
      debugPrint('Gift pledged successfully: $giftId');
    } catch (e) {
      debugPrint('Error pledging gift: $e');
      rethrow;
    }
  }

  // **Unpledge a gift**
  Future<void> unpledgeGift(String giftId) async {
    try {
      await repository.unpledgeGift(giftId);
      final index = gifts.indexWhere((gift) => gift.id == giftId);
      loadGifts(giftId);
      if (index != -1) {
        gifts[index] = gifts[index].copyWith(
          gifterId: '',
          status: 'Available',
        );
        notifyListeners();
      }
      debugPrint('Gift unpledged successfully: $giftId');
    } catch (e) {
      debugPrint('Error unpledging gift: $e');
      rethrow;
    }
  }
}
