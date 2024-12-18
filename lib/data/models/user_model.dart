import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.preferences,
  });

  // Convert from JSON to Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      preferences: json['preferences'],
    );
  }

  // Convert from Entity to Model (New method)
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      preferences: user.preferences,
    );
  }

  // Convert Model to Entity (New method)
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      preferences: preferences,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferences': preferences,
    };
  }
}