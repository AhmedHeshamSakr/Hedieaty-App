import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/event_tile.dart';
import 'event_controller.dart';


class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              controller.sortEvents(value);
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
        itemCount: controller.events.length,
        itemBuilder: (context, index) {
          final event = controller.events[index];
          return EventTile(
            eventName: event["name"]!,
            eventDate: DateTime.parse(event["date"]!), // Assuming date is stored as a string
            eventCategory: event["category"]!,
            eventStatus: event["status"]!,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new event logic here
          controller.addEvent({
            "name": "New Event",
            "date": DateTime.now().toIso8601String(),
            "category": "General",
            "status": "Upcoming",
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
