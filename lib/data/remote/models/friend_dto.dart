class FriendDTO {
  String? id; // Firestore document ID, optional for easier compatibility
  String userId;
  String friendId;

  FriendDTO({
    this.id,
    required this.userId,
    required this.friendId,
  });

  // Convert from Friend model to DTO (for uploading to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }

  // Convert from Firestore data to DTO (for reading from Firestore)
  factory FriendDTO.fromMap(Map<String, dynamic> map, String id) {
    return FriendDTO(
      id: id,
      userId: map['userId'],
      friendId: map['friendId'],
    );
  }
}
