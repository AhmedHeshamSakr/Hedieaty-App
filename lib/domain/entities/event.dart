// domain/entities/event.dart
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final String description;
  final String userId;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, name, date, location, description, userId];
}


