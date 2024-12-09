import 'package:firebase_database/firebase_database.dart';

import '../../models/user_model.dart';

class UserRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

  Future<void> createUser(UserModel user) async {
    await _dbRef.child(user.id).set(user.toJson());
  }

  Future<UserModel?> getUserById(String id) async {
    final snapshot = await _dbRef.child(id).get();
    if (snapshot.exists) {
      return UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final users = Map<String, dynamic>.from(snapshot.value as Map);
      return users.values.map((json) => UserModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  Future<void> updateUser(String id, UserModel user) async {
    await _dbRef.child(id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _dbRef.child(id).remove();
  }
}

