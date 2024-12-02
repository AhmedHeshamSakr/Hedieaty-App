import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/addFrinds/add_frinds_page.dart';
import 'package:hedieaty/presentation/routes/route_names.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/events/event_list_page.dart';
import '../pages/gifts/gift_list_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case RouteNames.home:
        return _buildHomeRoute(settings);
      case RouteNames.eventList:
        return MaterialPageRoute(builder: (_) => EventListPage());
      case RouteNames.giftList:
        return MaterialPageRoute(builder: (_) => GiftListPage());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case RouteNames.addFriend:
        return MaterialPageRoute(builder: (_) => const AddFriendsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found', style: TextStyle(fontSize: 18))),
          ),
        );
    }
  }

  static Route<dynamic> _buildHomeRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final userName = args?['userName'] ?? 'User';
    return MaterialPageRoute(builder: (_) => HomePage(userName: userName));
  }
}

