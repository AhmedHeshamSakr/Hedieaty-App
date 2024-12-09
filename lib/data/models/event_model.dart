import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.name,
    required super.date,
    required super.location,
    required super.description,
    required super.userId,
  });

  // Convert from JSON to Model
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      description: json['description'],
      userId: json['userId'],
    );
  }

  // Convert from Entity to Model (New method)
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      name: event.name,
      date: event.date,
      location: event.location,
      description: event.description,
      userId: event.userId,
    );
  }

  // Convert Model to Entity (New method)
  Event toEntity() {
    return Event(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description,
      userId: userId,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'userId': userId,
    };
  }
}