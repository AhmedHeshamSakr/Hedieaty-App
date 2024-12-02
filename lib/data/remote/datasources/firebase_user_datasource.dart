import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_dto.dart';

class FirestoreUserDataSource {
  Future<void> setUser(UserDTO userDTO) async {
    await FirebaseFirestore.instance.collection('users').doc(userDTO.id).set(userDTO.toMap());
  }

  Future<UserDTO?> getUser(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserDTO.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

}
