import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class EventTile extends StatelessWidget {
  final String eventName;
  final DateTime eventDate;
  final String eventCategory;
  final String eventStatus;

  const EventTile({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventCategory,
    required this.eventStatus,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMMMd().format(eventDate);
    final Color statusColor = eventStatus == "Upcoming"
        ? Colors.green
        : eventStatus == "Current"
        ? Colors.blue
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: const Icon(Icons.event, color: Colors.white),
        ),
        title: Text(
          eventName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Category: $eventCategory\nDate: $formattedDate",
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Add options like edit/delete here
          },
        ),
      ),
    );
  }
}
