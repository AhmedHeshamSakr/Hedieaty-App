import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/auth/login_page.dart';
import 'package:hedieaty/presentation/pages/auth/signup_page.dart';
import 'package:hedieaty/presentation/pages/home/home_page.dart';
import 'package:hedieaty/presentation/pages/events/event_list_page.dart';
import 'package:hedieaty/presentation/pages/gifts/gift_list_page.dart';
import 'package:hedieaty/presentation/pages/profile/profile_page.dart';
import 'package:hedieaty/presentation/routes/route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteNames.eventList:
        return MaterialPageRoute(builder: (_) => const EventListPage());
      case RouteNames.giftList:
        return MaterialPageRoute(builder: (_) => const GiftListPage());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}

