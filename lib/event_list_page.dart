// event_list_page.dart
import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  final List<Map<String, String>> events = [
    {"name": "Birthday Party", "category": "Personal", "status": "Upcoming"},
    {"name": "Wedding", "category": "Family", "status": "Past"},
    {"name": "Graduation", "category": "Celebration", "status": "Current"},
  ];

  EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
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
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index]["name"]!),
            subtitle: Text("${events[index]["category"]} - ${events[index]["status"]}"),
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
          // Add new event
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
