import 'dart:convert';

class UserModel {
  final int? id;
  final String firebaseUid; // Firebase UID
  final String name;
  final String email;
  final String preferences;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'name': name,
      'email': email,
      'preferences': jsonEncode(preferences),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firebaseUid: map['firebase_uid'],
      name: map['name'],
      email: map['email'],
      preferences: jsonDecode(map['preferences']),
    );
  }
}
