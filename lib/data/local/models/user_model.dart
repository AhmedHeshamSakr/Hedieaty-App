class UserModel {
  final int id;
  final String name;
  final String email;
  final String preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferences': preferences,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      preferences: map['preferences'],
    );
  }
}
