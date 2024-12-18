import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/gift.dart';
import '../../../domain/repositories/main_repository.dart';

class GiftController extends ChangeNotifier {
  final Repository repository;

  GiftController(this.repository);

  List<Gift> gifts = [];
  bool isLoading = true;

  // Fetch all gifts for a specific event
  Future<void> loadGifts(String eventId) async {
    isLoading = true;
    notifyListeners();

    try {
      gifts = await repository.getGifts(eventId);
    } catch (e) {
      debugPrint("Failed to load gifts: $e");
      gifts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGift(Gift gift) async {
    try {
      // Ensure the gift has a proper user ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      // Create a new gift with the current user's ID
      final newGift = gift.copyWith(
          userId: currentUser.uid,
          status: 'Available'
      );

      // Add the gift to the repository
      await repository.createGift(newGift);

      // Immediately reload gifts for this event to ensure the new gift appears
      await loadGifts(newGift.eventId);

      debugPrint('Gift added successfully: ${newGift.name}');
    } catch (e) {
      debugPrint('Error adding gift: $e');
      rethrow;
    }
  }


  // Update an existing gift
  Future<void> updateGift(Gift gift) async {
    try {
      // Validate gift data
      if (gift.id.isEmpty) {
        throw Exception('Invalid gift ID');
      }
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }
      final updatedGift = gift.copyWith(
          userId: currentUser.uid,
          status: gift.status.isNotEmpty ? gift.status : 'Available'
      );
      await repository.updateGift(updatedGift);
      int index = gifts.indexWhere((existingGift) => existingGift.id == updatedGift.id);
      if (index != -1) {
        gifts[index] = updatedGift;
      } else {
        gifts.add(updatedGift);
      }

      // Notify listeners about the state change
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating gift: $e');
      rethrow;
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


  // Delete a gift by its ID
  Future<void> deleteGift(String giftId) async {
    try {
      await repository.deleteGift(giftId);
      gifts.removeWhere((gift) => gift.id == giftId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting gift: $e');
      rethrow;
    }
  }

  // Sort gifts based on criteria (e.g., name, value, or status)
  void sortGifts(String criteria, {bool ascending = true}) {
    switch (criteria) {
      case 'name':
        gifts.sort((a, b) => ascending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'price':
        gifts.sort((a, b) => ascending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
        break;
      case 'status':
        const statusPriority = {'Available': 0, 'Pledged': 1, 'Purchased': 2};
        gifts.sort((a, b) {
          int priorityA = statusPriority[a.status] ?? 999;
          int priorityB = statusPriority[b.status] ?? 999;
          int comparison = priorityA.compareTo(priorityB);
          return ascending ? comparison : -comparison;
        });
        break;
    }
    notifyListeners();
  }
}