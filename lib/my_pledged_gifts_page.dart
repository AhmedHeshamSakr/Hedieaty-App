// my_pledged_gifts_page.dart
import 'package:flutter/material.dart';

class MyPledgedGiftsPage extends StatelessWidget {
  final List<Map<String, String>> pledgedGifts = [
    {"name": "Headphones", "friend": "Ahmed", "dueDate": "2024-12-25"},
    {"name": "Watch", "friend": "Ali", "dueDate": "2024-11-01"},
  ];

  MyPledgedGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Pledged Gifts")),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pledgedGifts[index]["name"]!),
            subtitle: Text("For: ${pledgedGifts[index]["friend"]} - Due: ${pledgedGifts[index]["dueDate"]}"),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Edit pledge if still valid
              },
            ),
          );
        },
      ),
    );
  }
}
