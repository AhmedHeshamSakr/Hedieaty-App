
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/event.dart';
import '../../widgets/custom_input_field.dart'; // Custom search input
import '../../widgets/friend_list_tile.dart'; // Friend list tile
import '../addFrinds/add_frinds_controller.dart';
import '../events/event_controller.dart';
import '../events/event_list_page.dart';
import 'home_controller.dart'; // HomePageController

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final friendsController = context.read<FriendsController>();
      if (friendsController.isLoading) {
        friendsController.loadFriends();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomePageController, FriendsController>(
      builder: (context, homeController, friendsController, child) {
        final filteredFriends = homeController.searchQuery.isEmpty
            ? friendsController.friendsDetails
            : friendsController.friendsDetails.where((user) {
          return user.name?.toLowerCase().contains(homeController.searchQuery) ?? false;
        }).toList();

        final FocusNode searchFocusNode = FocusNode();

        final List<Map<String, dynamic>> navItems = [
          {'icon': Icons.event, 'route': '/eventList', 'label': 'Events'},
          {'icon': Icons.person, 'route': '/profile', 'label': 'Profile'},
          {'icon': Icons.contact_phone, 'route': '/addFriend', 'label': 'Friends'},
        ];

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Hedieaty',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: "Logout",
                onPressed: () => homeController.logout(context),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => homeController.unfocusSearch(searchFocusNode),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCreateEventDialog(context);
                    },
                    child: const Text("Create an Event"),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    hintText: "Search Friends",
                    focusNode: searchFocusNode,
                    onChanged: (query) => homeController.handleSearch(query),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: friendsController.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : friendsController.friendsDetails.isEmpty
                        ? const Center(child: Text('No friends added yet'))
                        : RefreshIndicator(
                      onRefresh: () => friendsController.loadFriends(),
                      child: ListView.builder(
                        itemCount: homeController.filteredFriends.isEmpty
                            ? friendsController.friendsDetails.length
                            : homeController.filteredFriends.length,
                        itemBuilder: (context, index) {
                          final friend = homeController.filteredFriends.isEmpty
                              ? friendsController.friendsDetails[index]
                              : homeController.filteredFriends[index];
                          return FriendListTile(
                            friendName: friend.name ?? 'Unknown Friend',
                            profilePic: Icons.person,
                            upcomingEvents: 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventListPage(
                                    isViewOnly: true,
                                    friendId: friend.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeController.selectedIndex,
            onTap: (index) {
              homeController.onItemTapped(index);
              if (navItems[index]['route'] == '/profile') {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  Navigator.of(context).pushNamed(
                    navItems[index]['route'],
                    arguments: {'userId': userId},
                  );
                }
              } else {
                Navigator.of(context).pushNamed(navItems[index]['route']);
              }
            },
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            showUnselectedLabels: true,
            items: navItems.map((item) {
              return BottomNavigationBarItem(
                icon: Icon(item['icon']),
                label: item['label'],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final eventListController = context.read<EventListController>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDate;
    String status = "Upcoming";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
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
                      validator: (value) =>
                      value == null || value.isEmpty ? "Please enter the event name" : null,
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
                          setDialogState(() {
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
                        setDialogState(() {
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
                onPressed: () => Navigator.pop(context),
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
                    eventListController.addEvent(newEvent);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Create"),
              ),
            ],
          );
        },
      ),
    );
  }
}