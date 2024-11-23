// gift_list_page.dart
import 'package:flutter/material.dart';

class GiftListPage extends StatelessWidget {
  final List<Map<String, String>> gifts = [
    {"name": "Smartphone", "category": "Electronics", "status": "Available"},
    {"name": "Book", "category": "Literature", "status": "Pledged"},
  ];

  GiftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sort options
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "name", child: Text("Sort by Name")),
              const PopupMenuItem(value: "category", child: Text("Sort by Category")),
              const PopupMenuItem(value: "status", child: Text("Sort by Status")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          Color statusColor = gifts[index]["status"] == "Pledged"
              ? Colors.green
              : Colors.blue;
          return ListTile(
            title: Text(gifts[index]["name"]!),
            subtitle: Text("${gifts[index]["category"]} - ${gifts[index]["status"]}"),
            tileColor: statusColor.withOpacity(0.2),
            trailing: PopupMenuButton(
              onSelected: (value) {
                // Handle edit or delete actions
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "edit", child: Text("Edit")),
                const PopupMenuItem(value: "delete", child: Text("Delete")),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new gift
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
