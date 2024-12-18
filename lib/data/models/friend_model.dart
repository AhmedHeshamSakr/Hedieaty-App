import '../../domain/entities/friend.dart';

class FriendModel extends Friend {
  const FriendModel({
    required super.userId,
    required super.friendId,
  });

  // Convert from JSON to Model
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['userId'],
      friendId: json['friendId'],
    );
  }

  // Convert from Entity to Model (New method)
  factory FriendModel.fromEntity(Friend friend) {
    return FriendModel(
      userId: friend.userId,
      friendId: friend.friendId,
    );
  }

  // Convert Model to Entity (New method)
  Friend toEntity() {
    return Friend(
      userId: userId,
      friendId: friendId,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }

  // Add a `copyWith` method
  FriendModel copyWith({
    String? userId,
    String? friendId,
  }) {
    return FriendModel(
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
    );
  }
}
