import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/friend.dart';
import 'package:hedieaty/domain/repositories/friend_repository.dart';
import 'package:hedieaty/presentation/routes/navigation_service.dart';
import 'package:hedieaty/presentation/routes/route_names.dart';

class HomeController {
  final FriendRepository friendRepository;
  final FocusNode searchFocusNode = FocusNode();
  final List<BottomNavigationBarItem> bottomNavigationItems;
  final NavigationService navigationService;

  String userName = "User";
  int selectedIndex = 0;

  HomeController({
    required this.friendRepository,
    required this.navigationService,
  }) : bottomNavigationItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    const BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Gifts'),
    const BottomNavigationBarItem(icon: Icon(Icons.contact_phone), label: 'Add Friend'),
  ];

  Future<List<Friend>> getFriends() async {
    return await friendRepository.getAllFriends();
  }

  void onNavigationItemTapped(int index) {
    selectedIndex = index;
    final routes = [
      RouteNames.eventList,
      RouteNames.profile,
      RouteNames.giftList,
      RouteNames.addFriend
    ];
    if (index < routes.length) {
      navigationService.navigateTo(routes[index]);
    }
  }

  void logout() {
    navigationService.replaceWith(RouteNames.login);
  }

  void createEvent() {
    navigationService.navigateTo(RouteNames.createEvent);
  }

  void searchFriends(String query) {
    // Handle friend search logic
  }

  void openFriendGifts(Friend friend) {
    navigationService.navigateTo(RouteNames.friendGiftList, arguments: friend);
  }

  void dispose() {
    searchFocusNode.dispose();
  }
}