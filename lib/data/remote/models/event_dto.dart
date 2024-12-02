class EventDTO {
  String? id; // Firestore document ID
  String name;
  String date;
  String location;
  String description;
  String userId;

  EventDTO({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  // Convert from Event model to DTO (for uploading to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'userId': userId,
    };
  }

  // Convert from Firestore data to DTO (for reading from Firestore)
  factory EventDTO.fromMap(Map<String, dynamic> map, String id) {
    return EventDTO(
      id: id,
      name: map['name'],
      date: map['date'],
      location: map['location'],
      description: map['description'],
      userId: map['userId'],
    );
  }
}
