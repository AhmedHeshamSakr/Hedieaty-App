import 'package:flutter/material.dart';

// Controller for managing friends
class FriendsController with ChangeNotifier {
  final List<Map<String, String>> friends = [];

  void addFriend(Map<String, String> newFriend) {
    friends.add(newFriend);
    notifyListeners();
  }

  void deleteFriend(int index) {
    friends.removeAt(index);
    notifyListeners();
  }
}
