class UserDTO {
  String id;
  String name;
  String email;
  Map<String, dynamic> preferences;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  // Convert from User model to DTO (for uploading to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'preferences': preferences,
    };
  }

  // Convert from Firebase data to DTO (for reading from Firebase)
  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      preferences: map['preferences'],
    );
  }
}
