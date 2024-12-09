import 'package:firebase_database/firebase_database.dart';

import '../../models/gift_model.dart';

class GiftRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("gifts");

  Future<void> createGift(GiftModel gift) async {
    await _dbRef.child(gift.id).set(gift.toJson());
  }

  Future<GiftModel?> getGiftById(String id) async {
    final snapshot = await _dbRef.child(id).get();
    if (snapshot.exists) {
      return GiftModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<GiftModel>> fetchAllGifts() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final gifts = Map<String, dynamic>.from(snapshot.value as Map);
      return gifts.values.map((json) => GiftModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  Future<void> updateGift(String id, GiftModel gift) async {
    await _dbRef.child(id).update(gift.toJson());
  }

  Future<void> deleteGift(String id) async {
    await _dbRef.child(id).remove();
  }
}

