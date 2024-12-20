import '../../domain/entities/gift.dart';

class GiftModel extends Gift {
  const GiftModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.price,
    required super.status,
    required super.eventId,
    required super.userId,
    required super.gifterId,
  });

  // Convert from JSON to Model
  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      status: json['status'],
      eventId: json['eventId'],
      userId: json['userId'],
      gifterId: json['gifterId'],
    );
  }

  // Convert from Entity to Model (New method)
  factory GiftModel.fromEntity(Gift gift) {
    return GiftModel(
      id: gift.id,
      name: gift.name,
      description: gift.description,
      category: gift.category,
      price: gift.price,
      status: gift.status,
      eventId: gift.eventId,
      userId: gift.userId,
      gifterId: gift.gifterId,
    );
  }

  // Convert Model to Entity (New method)
  Gift toEntity() {
    return Gift(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      status: status,
      eventId: eventId,
      userId: userId,
      gifterId: gifterId,
    );
  }

  // Convert Model to JSON
  @override
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

}