import 'package:flutter/material.dart';
import '../../routes/navigation_service.dart';
import '../../routes/route_names.dart'; // Your route names

class HomePageController extends ChangeNotifier {
  int _selectedIndex = 0;

  // The list of routes and icons corresponding to each bottom navigation item
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.event, 'route': RouteNames.eventList},
    {'icon': Icons.person, 'route': RouteNames.profile},
    {'icon': Icons.card_giftcard, 'route': RouteNames.giftList},
    {'icon': Icons.contact_phone, 'route': RouteNames.addFriend},
  ];

  int get selectedIndex => _selectedIndex;
  List<Map<String, dynamic>> get navItems => _navItems;

  // Method to handle navigation and updating the selected tab
  void onItemTapped(int index, BuildContext context) {
    if (_selectedIndex == index) return; // Prevent unnecessary navigation

    _selectedIndex = index; // Update selected index immediately
    notifyListeners(); // Notify listeners so UI can rebuild with the new selected index

    final route = _navItems[index]['route'];

    // Navigate to the selected route using NavigationService
    NavigationService().navigateTo(route).then((_) {
      // Optionally reset the index to home (0) when returning to the home page
      if (route == RouteNames.home) {
        _selectedIndex = 0; // Reset to home tab when navigating back to home page
        notifyListeners();
      }
    });
  }

  void logout(BuildContext context) {
    _selectedIndex = 0; // Reset to home tab on logout
    notifyListeners();

    // Navigate to login screen and clear navigation stack
    NavigationService().navigateAndClear(RouteNames.login);
  }

  void unfocusSearch(FocusNode searchFocusNode) {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }
}
