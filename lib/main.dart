// main.dart
import 'package:flutter/material.dart';
import 'add_friend_page.dart';
import 'home_page.dart';
import 'event_list_page.dart';
import 'gift_list_page.dart';
import 'gift_details_page.dart';
import 'profile_page.dart';
import 'my_pledged_gifts_page.dart';
import 'login_Page.dart';
import 'sign_up_page.dart';



void main() {
  runApp(const HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  const HedieatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(userName: 'Ahmed'),
        '/eventList': (context) => EventListPage(),
        '/giftList': (context) => GiftListPage(),
        '/giftDetails': (context) => const GiftDetailsPage(),
        '/profile': (context) => const ProfilePage(),
        '/myPledgedGifts': (context) => MyPledgedGiftsPage(),
        '/addFriend': (context) => const AddFriendPage(),
      },
    );
  }
}
