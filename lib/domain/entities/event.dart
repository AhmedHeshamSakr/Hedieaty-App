import '../../data/local/models/event_model.dart';
import '../../data/remote/models/event_dto.dart';

class Event {
  int? id;
  String name;
  DateTime date;
  String location;
  String description;
  String status;

  Event({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.status,
  });

  /// Converts an [EventModel] to an [Event] entity
  factory Event.fromModel(EventModel model) {
    return Event(
      id: model.id,
      name: model.name,
      date: model.date,
      location: model.location,
      description: model.description,
      status: model.status, // Default to empty string if status is null
    );
  }

  /// Converts an [EventDTO] to an [Event] entity
  factory Event.fromDTO(EventDTO dto) {
    return Event(
      id: dto.id != null ? int.tryParse(dto.id!) : null,
      name: dto.name,
      date: dto.date,
      location: dto.location,
      description: dto.description,
      status: dto.status, // Default to empty string if status is null
    );
  }

  /// Converts this entity to an [EventModel] for local storage
  EventModel toModel() {
    return EventModel(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description,
      status: status,
    );
  }

  /// Converts this entity to an [EventDTO] for remote usage
  EventDTO toDTO() {
    return EventDTO(
      id: id?.toString(),
      name: name,
      date: date,
      location: location,
      description: description,
      status: status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Event &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              date == other.date &&
              location == other.location &&
              description == other.description &&
              status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      date.hashCode ^
      location.hashCode ^
      description.hashCode ^
      status.hashCode;
}
