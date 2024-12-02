class Friend {
  final int id;
  final String name;
  final String phone;

  Friend({
    required this.id,
    required this.name,
    required this.phone,
  });

  // Equality and hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Friend &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              phone == other.phone;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode;
}