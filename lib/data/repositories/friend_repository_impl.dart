import '../../domain/repositories/friend_repository.dart';
import '../local/datasources/sqlite_friend_datasource.dart';
import '../local/models/friend_model.dart';

class FriendRepositoryImpl implements FriendRepository{
  final SqliteFriendDatasource localDatasource;

  FriendRepositoryImpl(this.localDatasource);

  @override
  Future<List<FriendModel>> getAllFriends() async {
    return await localDatasource.getAllFriends();
  }

  @override
  Future<void> addFriend(FriendModel friend) async {
    await localDatasource.insertFriend(friend);
  }

  @override
  Future<void> removeFriend(int friendId) async {
    await localDatasource.deleteFriend(friendId);
  }
}
