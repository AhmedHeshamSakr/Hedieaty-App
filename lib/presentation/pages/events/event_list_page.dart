import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/event.dart';
import '../../widgets/event_tile.dart';
import 'event_controller.dart';



class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  void _showCreateEventDialog(BuildContext context) {
    final controller = context.read<EventListController>();
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    String status = "Upcoming";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Event"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Event Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the event name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  ListTile(
                    title: const Text("Date"),
                    subtitle: Text(
                      selectedDate == null
                          ? "Select a date"
                          : "${selectedDate?.toLocal()}".split(' ')[0],
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(value: "Upcoming", child: Text("Upcoming")),
                      DropdownMenuItem(value: "Ongoing", child: Text("Ongoing")),
                      DropdownMenuItem(value: "Completed", child: Text("Completed")),
                    ],
                    onChanged: (value) {
                      status = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newEvent = Event(
                    name: nameController.text,
                    location: locationController.text,
                    description: descriptionController.text,
                    date: selectedDate ?? DateTime.now(),
                    status: status, userId: null, id: '',
                  );
                  controller.addEvent(newEvent); // Add the new event
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

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
              const PopupMenuItem(value: "location", child: Text("Sort by Location")),
              const PopupMenuItem(value: "status", child: Text("Sort by Status")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showCreateEventDialog(context);
              },
              child: const Text("Create Event"),
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.events.isEmpty
                ? const Center(child: Text("No events found."))
                : ListView.builder(
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final event = controller.events[index];
                return EventTile(
                  eventName: event.name,
                  eventDate: event.date,
                  eventCategory: event.location, // Use `location` for category
                  eventStatus: event.status,
                  onDelete: () {
                    controller.deleteEvent(event.id!); // Use ID for deletion
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}