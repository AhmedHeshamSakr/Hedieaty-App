class UserDTO {
  String? id; // Optional Firestore document ID
  String name;
  String email;
  Map<String, dynamic> preferences;

  UserDTO({
    this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  // Convert from User model to DTO (for uploading to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'preferences': preferences,
    };
  }

  // Convert from Firestore data to DTO (for reading from Firestore)
  factory UserDTO.fromMap(Map<String, dynamic> map, String id) {
    return UserDTO(
      id: id,
      name: map['name'],
      email: map['email'],
      preferences: map['preferences'] as Map<String, dynamic>,
    );
  }
}
