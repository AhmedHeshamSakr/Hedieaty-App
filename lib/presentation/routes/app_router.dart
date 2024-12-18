import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/addFrinds/add_frinds_page.dart';
import 'package:hedieaty/presentation/routes/route_names.dart';
import 'package:provider/provider.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/events/event_list_page.dart';
import '../pages/gifts/gift_controller.dart';
import '../pages/gifts/gift_list_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';



class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => SignupPage());

      case RouteNames.home:
        return _buildHomeRoute(settings);

      case RouteNames.eventList:
      // Handle optional isViewOnly parameter
        final args = settings.arguments as Map?;
        final bool isViewOnly = args?['isViewOnly'] ?? false;
        return MaterialPageRoute(
            builder: (_) => EventListPage(
              isViewOnly: isViewOnly,
            )
        );

      case RouteNames.giftList:
        return _buildGiftListRoute(settings);

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

  static Route _buildHomeRoute(RouteSettings settings) {
    final args = settings.arguments as Map?;
    final userName = args?['userName'] ?? 'User';
    return MaterialPageRoute(builder: (_) => HomePage(userName: userName));
  }

  static Route _buildGiftListRoute(RouteSettings settings) {
    // Ensure that the arguments are provided and have the correct type
    final args = settings.arguments as Map<String, dynamic>;
    final String eventId = args['eventId'];
    // Add optional isViewOnly with default false
    final bool isViewOnly = args['isViewOnly'] ?? false;

    return MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider.value(
        value: context.read<GiftController>(),
        child: GiftListPage(
          eventId: eventId,
          isViewOnly: isViewOnly,
        ),
      ),
    );
  }
}