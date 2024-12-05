import 'package:firebase_database/firebase_database.dart';
import '../models/user_dto.dart';


class FirebaseUserDataSource {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Future<void> setUser(UserDTO userDTO) async {
    final userRef = _database.child('users').child(userDTO.id as String);
    await userRef.set(userDTO.toMap());
  }
  Future<UserDTO> getUser(String userId) async {
    final snapshot = await _database.child('users').child(userId).once();
    final userMap = snapshot.snapshot.value as Map<String, dynamic>;
    return UserDTO.fromMap(userMap);
  }
}