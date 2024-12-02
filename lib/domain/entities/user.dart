class User {
  final String id;
  final String name;
  final String email;
  final String preferences; // Could be a more structured object if needed

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  // Equality and hashCode
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