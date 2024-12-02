class Gift {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status; // Could be an enum instead of a string
  final int eventId;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
  });

  // Equality and hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Gift &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              category == other.category &&
              price == other.price &&
              status == other.status &&
              eventId == other.eventId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      category.hashCode ^
      price.hashCode ^
      status.hashCode ^
      eventId.hashCode;
}