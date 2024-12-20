import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/presentation/pages/pledged_gifts/pledge_controller.dart';
import 'package:provider/provider.dart';

import '../gifts/gift_controller.dart';
import '../gifts/gift_details_page.dart';

class PledgedGiftsListPage extends StatefulWidget {
  const PledgedGiftsListPage({super.key});

  @override
  State<PledgedGiftsListPage> createState() => _PledgedGiftsListPageState();
}

class _PledgedGiftsListPageState extends State<PledgedGiftsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final currentUserId = user.uid;
        await context.read<PledgedGiftsController>().loadGifts(currentUserId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No authenticated user found!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pledgedGiftsController = context.watch<PledgedGiftsController>();
    final giftController = context.watch<GiftController>();


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pledged Gifts"),
      ),
      body: Column(
        children: [
          Expanded(
            child: pledgedGiftsController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : pledgedGiftsController.gifts.isEmpty
                ? const Center(child: Text('No gifts pledged yet.'))
                : ListView.builder(
              itemCount: pledgedGiftsController.gifts.length,
              itemBuilder: (context, index) {
                final gift = pledgedGiftsController.gifts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  color: Colors.lightGreen[50],
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/gifts_defualt.webp'),
                    ),
                    title: Text(
                      gift.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Price: \$${gift.price.toStringAsFixed(2)}'),
                    trailing: Text(
                      gift.status,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftDetailsPage(
                            gift: gift,
                            isViewOnly: true, // Set `isViewOnly` to true for pledged gifts
                            giftController: giftController,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
