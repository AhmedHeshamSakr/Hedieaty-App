import 'package:flutter/material.dart';

// User Controller
class UserController with ChangeNotifier {
  Map<String, String> userProfile = {
    "name": "John Doe",
    "email": "johndoe@example.com",
    "phone": "123-456-7890",
  };

  bool notificationsEnabled = true;

  void updateUserProfile(String key, String value) {
    userProfile[key] = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }
}

