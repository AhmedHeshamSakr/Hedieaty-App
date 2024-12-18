import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final String eventId;
  final String userId;
  final String? gifterId;

  const Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    required this.userId,
    this.gifterId,
  });

  Gift copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    String? status,
    String? eventId,
    String? userId,
    String? gifterId,
  }) {
    return Gift(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      gifterId: gifterId ?? this.gifterId,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'eventId': eventId,
      'userId': userId,
      'gifterId': gifterId,
    };
  }

  @override
  List<Object?> get props => [id, name, description, category, price, status, eventId, userId, gifterId];
}
