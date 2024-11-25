class GiftModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final int eventId;

  GiftModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'eventId': eventId,
    };
  }

  factory GiftModel.fromMap(Map<String, dynamic> map) {
    return GiftModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['eventId'],
    );
  }
}
