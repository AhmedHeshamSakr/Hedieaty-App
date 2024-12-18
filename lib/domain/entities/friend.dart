import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final String userId;
  final String friendId;

  const Friend({
    required this.userId,
    required this.friendId,
  });

  @override
  List<Object?> get props => [userId, friendId];
}
