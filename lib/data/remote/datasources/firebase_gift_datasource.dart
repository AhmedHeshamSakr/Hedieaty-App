import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:hedieaty/domain/entities/gift.dart';

import '../../models/gift_model.dart';

class GiftRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("gifts");
  final DatabaseReference _friendsRef = FirebaseDatabase.instance.ref("friends");



  Future<GiftModel> createGift(GiftModel gift) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }
    final newGiftRef = _dbRef.push();
    final String firebaseGiftId = newGiftRef.key!;

    final GiftModel giftToCreate = GiftModel(
      id: firebaseGiftId,
      name: gift.name,
      description: gift.description,
      eventId: gift.eventId,
      userId: currentUser.uid,
      gifterId: gift.gifterId,
      status: 'Available', // Default status
      category: gift.category,
      price: gift.price,
    );
    await newGiftRef.set(giftToCreate.toJson());
    return giftToCreate;
  }

  Future<void> pledgeGift(String giftId, String gifterId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    try {
      final snapshot = await _dbRef.child(giftId).get();
      if (!snapshot.exists) {
        throw Exception('Gift not found');
      }

      await _dbRef.child(giftId).update({
        'gifterId': gifterId,
        'status': 'Pledged',
      });
      debugPrint('Gift $giftId pledged successfully by $gifterId');
    } catch (e) {
      debugPrint('Error pledging gift $giftId: $e');
      throw Exception('Failed to pledge gift $giftId');
    }
  }

  Future<void> unpledgeGift(String giftId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    try {
      final snapshot = await _dbRef.child(giftId).get();
      if (!snapshot.exists) {
        throw Exception('Gift not found');
      }

      await _dbRef.child(giftId).update({
        'gifterId': null,
        'status': 'Available',
      });
      debugPrint('Gift $giftId unpledged successfully');
    } catch (e) {
      debugPrint('Error unpledging gift $giftId: $e');
      throw Exception('Failed to unpledge gift $giftId');
    }
  }


  Future<List<GiftModel>> fetchGiftsByEvent(String eventId) async {
    final snapshot = await _dbRef
        .orderByChild('eventId')
        .equalTo(eventId)
        .get();

    if (snapshot.exists) {
      final giftsMap = snapshot.value as Map<dynamic, dynamic>;
      return giftsMap.values
          .map((json) => GiftModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }

    return [];
  }

  Future<GiftModel?> getGiftById(String id) async {
    final snapshot = await _dbRef.child(id).get();
    if (snapshot.exists) {
      return GiftModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<GiftModel>> fetchGiftsByUserId(String userId) async {
    final snapshot = await _dbRef.orderByChild("userId").equalTo(userId).get();
    if (snapshot.exists) {
      final gifts = Map<String, dynamic>.from(snapshot.value as Map);
      return gifts.values.map((json) => GiftModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  Future<List<GiftModel>> fetchGiftsByEventAndStatus(String eventId, String status) async {
    final snapshot = await _dbRef
        .orderByChild("eventId")
        .equalTo(eventId)
        .get();
    if (snapshot.exists) {
      final gifts = Map<String, dynamic>.from(snapshot.value as Map);
      return gifts.values
          .where((json) => Map<String, dynamic>.from(json)["status"] == status)
          .map((json) => GiftModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }
    return [];
  }



  Future<GiftModel?> updateGift(GiftModel updatedGift) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    final existingGiftSnapshot = await _dbRef.child(updatedGift.id).get();
    if (!existingGiftSnapshot.exists) {
      return null; // Gift doesn't exist
    }
    final existingGiftData = Map<String, dynamic>.from(existingGiftSnapshot.value as Map);
    final existingGift = GiftModel.fromJson(existingGiftData);
    if (existingGift.userId != currentUser.uid) {
      throw Exception('You do not have permission to update this gift');
    }
    await _dbRef.child(updatedGift.id).update(updatedGift.toJson());

    return updatedGift;
  }



  Future<void> deleteGift(String id) async {
    await _dbRef.child(id).remove();
  }
}

