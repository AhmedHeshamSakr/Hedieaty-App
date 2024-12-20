import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../../../data/utils/notification_service.dart';
import '../../../data/utils/theme_controller.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/main_repository.dart';


class UserController with ChangeNotifier {
  final Repository repository;


  User? _user;
  bool notificationsEnabled = true;

  UserController(this.repository);

  User? get user => _user;

  Future<void> fetchUser(String userId) async {
    try {
      _user = await repository.getUser(userId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> updateUserProfile(String key, String value) async {
    if (_user == null) return;

    // Create a new User instance with updated fields
    final updatedUser = User(
      id: _user!.id,
      name: key == 'name' ? value : _user!.name,
      email: key == 'email' ? value : _user!.email,
      preferences: key == 'preferences' ? value : _user!.preferences,
    );

    try {
      await repository.updateUser(updatedUser);
      _user = updatedUser; // Update local state
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating user profile: $e");
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;

    if (notificationsEnabled) {
      NotificationService.initializeNotification();
    } else {
      AwesomeNotifications().cancelAll();
    }

    notifyListeners();
  }

  void toggleDarkTheme(bool value) {}
}
