class EventDTO {
  String id;
  String name;
  String date;
  String location;
  String description;
  String userId;

  EventDTO({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  // Convert from Event model to DTO (for uploading to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'userId': userId,
    };
  }

  // Convert from Firebase data to DTO (for reading from Firebase)
  factory EventDTO.fromMap(Map<String, dynamic> map) {
    return EventDTO(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      location: map['location'],
      description: map['description'],
      userId: map['userId'],
    );
  }
}
