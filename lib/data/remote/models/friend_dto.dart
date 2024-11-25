class FriendDTO {
  String userId;
  String friendId;

  FriendDTO({
    required this.userId,
    required this.friendId,
  });

  // Convert from Friend model to DTO (for uploading to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }

  // Convert from Firebase data to DTO (for reading from Firebase)
  factory FriendDTO.fromMap(Map<String, dynamic> map) {
    return FriendDTO(
      userId: map['userId'],
      friendId: map['friendId'],
    );
  }
}
