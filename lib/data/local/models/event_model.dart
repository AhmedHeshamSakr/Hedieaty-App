import '../../../domain/entities/event.dart';

class EventModel {
  int? id;
  String name;
  DateTime date;
  String location;
  String description;
  String status; // Added status field

  EventModel({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.status, // Added status in constructor
  });

  /// Converts an `EventModel` to a Map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'status': status, // Add status to map
    };
  }

  /// Static factory method for creating an `EventModel` from a Map.
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      name: map['name'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      description: map['description'],
      status: map['status'], // Parse status from map
    );
  }

  /// Converts an `EventModel` to an `Event` entity.
  Event toEntity() {
    return Event(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description,
      status: status, // Add status
    );
  }

  /// Static factory method for creating an `EventModel` from an `Event` entity.
  static EventModel fromEntity(Event event) {
    return EventModel(
      id: event.id,
      name: event.name,
      date: event.date,
      location: event.location,
      description: event.description,
      status: event.status, // Add status
    );
  }
}
