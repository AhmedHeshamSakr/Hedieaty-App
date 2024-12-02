class Event {
  final int id;
  final String name;
  final DateTime date;
  final String location;
  final String description;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
  });

  // Equality and hashCode for easier comparison and testing
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Event &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              date == other.date &&
              location == other.location &&
              description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ date.hashCode ^ location.hashCode ^ description.hashCode;
}