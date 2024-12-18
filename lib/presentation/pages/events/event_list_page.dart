import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/event.dart';
import '../../widgets/event_tile.dart';
import '../gifts/gift_list_page.dart';
import 'event_controller.dart';


class EventListPage extends StatefulWidget {
  final bool isViewOnly;
  final String? friendId;
  final String? friendName; // New optional parameter

  const EventListPage({super.key, required this.isViewOnly, this.friendId, this.friendName});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {

  String _friendName = 'Friend';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<EventListController>();

      if (widget.isViewOnly && widget.friendId != null) {
        controller.loadFriendEvents(widget.friendId!);
        _fetchFriendName();
      } else {
        controller.resetEvents();  // Ensure you load your events when viewing your own events
      }
    });
  }

  Future<void> _fetchFriendName() async {
    final controller = context.read<EventListController>();
    final name = await controller.getFriendName(widget.friendId!);
    if (mounted) {
      setState(() {
        _friendName = name;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventListController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isViewOnly
              ? "$_friendName's Events"
              : "Events",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.isViewOnly)
                    ElevatedButton.icon(
                      onPressed: () => _showCreateEventDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text("Add Event"),
                    ),
                  ElevatedButton.icon(
                    onPressed: () => _showSortingBottomSheet(context),
                    icon: const Icon(Icons.sort),
                    label: const Text("Sort"),
                  ),
                ],
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftListPage(
                          eventId: event.id,
                          isViewOnly: widget.isViewOnly,  // Pass view-only status
                        ),
                      ),
                    );
                  },
                  child: EventTile(
                    eventName: event.name,
                    eventDate: event.date,
                    eventCategory: event.location,
                    eventStatus: event.status,
                    // Only show delete and edit if not in view-only mode
                    onDelete: !widget.isViewOnly ? () {
                      controller.deleteEvent(event.id);
                    } : null,
                    onEdit: !widget.isViewOnly ? () {
                      _showEditEventDialog(context, event);
                    } : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
        builder: (context) => StatefulBuilder(
      builder: (context, setDialogState){
        return AlertDialog(
          title: const Text("Add Event"),
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
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(value: "Upcoming", child: Text("Upcoming")),
                      DropdownMenuItem(value: "Current", child: Text("Ongoing")),
                      DropdownMenuItem(value: "Past", child: Text("Completed")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
                    status: status,
                    id: '',
                    userId: '',
                  );
                  controller.addEvent(newEvent);
                  Navigator.pop(context);
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
        )
    );
  }

  void _showSortingBottomSheet(BuildContext context) {
    final controller = context.read<EventListController>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Name'),
                onTap: () {
                  controller.sortEvents('name');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Sort by Date'),
                onTap: () {
                  controller.sortEvents('date');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment_turned_in),
                title: const Text('Sort by Status'),
                onTap: () {
                  controller.sortEvents('status');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    final controller = context.read<EventListController>();
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
    TextEditingController(text: event.name);
    final TextEditingController locationController =
    TextEditingController(text: event.location);
    final TextEditingController descriptionController =
    TextEditingController(text: event.description);
    DateTime selectedDate = event.date;
    String status = event.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Event"),
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
                      "${selectedDate.toLocal()}".split(' ')[0],
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
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
                      DropdownMenuItem(value: "Current", child: Text("Ongoing")),
                      DropdownMenuItem(value: "Past", child: Text("Completed")),
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
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedEvent = Event(
                    id: event.id, // Retain the same ID
                    name: nameController.text,
                    location: locationController.text,
                    description: descriptionController.text,
                    date: selectedDate,
                    status: status,
                    userId: event.userId, // Retain the same userId
                  );
                  controller.updateEvent(updatedEvent);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}