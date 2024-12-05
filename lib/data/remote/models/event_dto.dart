import '../../local/models/event_model.dart';

class EventDTO {
  String? id; // Firebase's auto-generated ID
  String name;
  DateTime date;
  String location;
  String description;
  String status; // Added status field

  EventDTO({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.status, // Added status in constructor
  });

  factory EventDTO.fromMap(Map<dynamic, dynamic> map) {
    return EventDTO(
      id: map['id'] as String?,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      location: map['location'] as String,
      description: map['description'] as String,
      status: map['status'] as String, // Parse status from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'status': status, // Include status in map
    };
  }

  /// Converts an `EventModel` to an `EventDTO`.
  static EventDTO fromEventModel(EventModel model) {
    return EventDTO(
      id: model.id?.toString(),
      name: model.name,
      date: model.date,
      location: model.location,
      description: model.description,
      status: model.status, // Set status from EventModel
    );
  }

  /// Converts an `EventDTO` to an `EventModel`.
  EventModel toEventModel() {
    return EventModel(
      id: int.tryParse(id ?? ''),
      name: name,
      date: date,
      location: location,
      description: description,
      status: status, // Set status in EventModel
    );
  }
}
