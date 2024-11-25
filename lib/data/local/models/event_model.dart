class EventModel {
  final int id;
  final String name;
  final DateTime date;
  final String location;
  final String description;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      description: map['description'],
    );
  }
}
