import '../repositories/friend_repository.dart';
import '../../data/local/models/friend_model.dart';

class GetFriendsUseCase {
  final FriendRepository friendRepository;

  GetFriendsUseCase(this.friendRepository);

  Future<List<FriendModel>> execute() async {
    try {
      return await friendRepository.getAllFriends();
    } catch (e) {
      throw Exception('Error fetching friends: ${e.toString()}');
    }
  }
}