import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/routes/route_names.dart';


import '../../event_list_page.dart';
import '../../gift_list_page.dart';
import '../../home_page.dart';
import '../../login_Page.dart';
import '../../profile_page.dart';
import '../../sign_up_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteNames.eventList:
        return MaterialPageRoute(builder: (_) => EventListPage());
      case RouteNames.giftList:
        return MaterialPageRoute(builder: (_) =>  GiftListPage());
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

