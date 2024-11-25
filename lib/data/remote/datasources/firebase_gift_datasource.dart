import 'package:firebase_database/firebase_database.dart';
import '../models/gift_dto.dart';

class FirebaseGiftDataSource {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> addGift(GiftDTO giftDTO) async {
    final giftRef = _database.child('events').child(giftDTO.eventId).child('gifts').push();
    await giftRef.set(giftDTO.toMap());
  }

  Future<void> updateGiftStatus(String giftId, String status, String pledgedBy) async {
    final giftRef = _database.child('events').child(giftId);
    await giftRef.update({'status': status, 'pledgedBy': pledgedBy});
  }

  Future<List<GiftDTO>> getGiftsByEventId(String eventId) async {
    final snapshot = await _database.child('events').child(eventId).child('gifts').once();
    final giftsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
    return giftsMap.values.map((gift) => GiftDTO.fromMap(gift)).toList();
  }
}
