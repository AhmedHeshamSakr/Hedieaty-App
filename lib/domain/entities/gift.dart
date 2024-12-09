import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final String eventId;

  const Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
  });

  @override
  List<Object?> get props => [id, name, description, category, price, status, eventId];
}
