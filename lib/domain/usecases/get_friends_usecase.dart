import '../../data/local/models/friend_model.dart';
import '../repositories/friend_repository.dart';

class GetFriendsUseCase {
  final FriendRepository repository;

  GetFriendsUseCase(this.repository);

  Future<List<FriendModel>> call() async {
    return await repository.getAllFriends();
  }
}
