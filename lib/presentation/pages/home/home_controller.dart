import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/main_repository.dart';

class HomePageController extends ChangeNotifier {
  final Repository repository;
  HomePageController(this.repository);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  final List<User> _friends = []; // Initialize as an empty list

  List<User> _filteredFriends = [];
  List<User> get filteredFriends => _filteredFriends;


  void handleSearch(String query) {
    _searchQuery = query.toLowerCase();
    _filteredFriends = query.isEmpty
        ? List.from(_friends)
        : _friends.where((friend) =>
    friend.name?.toLowerCase().contains(_searchQuery) ?? false).toList();
    notifyListeners();
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _selectedIndex = 0;
    notifyListeners();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void unfocusSearch(FocusNode searchFocusNode) {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }
}