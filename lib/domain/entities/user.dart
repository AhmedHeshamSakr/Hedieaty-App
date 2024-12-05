import 'dart:convert';
import '../../data/local/models/user_model.dart';
import '../../data/remote/models/user_dto.dart';

class User {
  final int? id; // Primary ID as int for this layer
  final String name;
  final String email;
  final Map<String, dynamic> preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  /// Converts a [UserModel] to a [User] entity
  factory User.fromModel(UserModel model) {
    return User(
      id: model.id, // Assuming UserModel.id is int? as well
      name: model.name,
      email: model.email,
      preferences: jsonDecode(model.preferences) as Map<String, dynamic>,
    );
  }

  /// Converts a [UserDTO] to a [User] entity
  factory User.fromDTO(UserDTO dto) {
    return User(
      id: dto.id != null ? int.tryParse(dto.id!) : null, // Convert String? to int?
      name: dto.name,
      email: dto.email,
      preferences: dto.preferences,
    );
  }

  /// Converts this entity to a [UserModel] for local storage
  UserModel toModel() {
    return UserModel(
      id: id, // Direct assignment as UserModel expects int?
      name: name,
      email: email,
      preferences: jsonEncode(preferences), // Encode preferences as JSON
    );
  }

  /// Converts this entity to a [UserDTO] for remote usage
  UserDTO toDTO() {
    return UserDTO(
      id: id?.toString(), // Convert int? to String?
      name: name,
      email: email,
      preferences: preferences, // Assuming DTO expects a Map
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email &&
              preferences == other.preferences;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ email.hashCode ^ preferences.hashCode;
}
