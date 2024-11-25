class GiftDTO {
  String id;
  String name;
  String description;
  String category;
  double price;
  String status;
  String eventId;
  String pledgedBy;

  GiftDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    required this.pledgedBy,
  });

  // Convert from Gift model to DTO (for uploading to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'eventId': eventId,
      'pledgedBy': pledgedBy,
    };
  }

  // Convert from Firebase data to DTO (for reading from Firebase)
  factory GiftDTO.fromMap(Map<String, dynamic> map) {
    return GiftDTO(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['eventId'],
      pledgedBy: map['pledgedBy'],
    );
  }
}
