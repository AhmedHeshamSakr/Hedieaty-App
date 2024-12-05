

// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_frinds_controller.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  @override
  Widget build(BuildContext context) {
    final friendsController = Provider.of<FriendsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friends"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: friendsController.friends.length,
              itemBuilder: (context, index) {
                final friend = friendsController.friends[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(friend["name"] ?? "No Name"),
                    subtitle: Text("Phone: ${friend["phone"] ?? "N/A"}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        friendsController.deleteFriend(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddFriendDialog(context, friendsController);
              },
              child: const Text("Add Friend Manually"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // _getContacts(context, friendsController);
              },
              child: const Text("Add Friend from Contacts"),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, FriendsController controller) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Friend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Friend's Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.addFriend({
                  "name": nameController.text,
                  "phone": phoneController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _getContacts(BuildContext context, FriendsController controller) async {
  //   try {
  //     Iterable<Contact> contacts = await ContactsService.getContacts();
  //
  //     // Check if the widget is still mounted before updating the UI
  //     if (!mounted) return;
  //
  //     List<Map<String, String>> contactList = contacts
  //         .map((contact) => {
  //       "name": contact.displayName ?? "Unknown",
  //       "phone": contact.phones?.isNotEmpty == true
  //           ? contact.phones!.first.value ?? "N/A"
  //           : "N/A",
  //     })
  //         .toList();
  //
  //     // Optionally, show contacts in a dialog for user to select one to add
  //     if (contactList.isNotEmpty) {
  //       _showContactPickerDialog(context, controller, contactList);
  //     }
  //   } catch (e) {
  //     print("Error fetching contacts: $e");
  //   }
  // }

  void _showContactPickerDialog(
      BuildContext context, FriendsController controller, List<Map<String, String>> contacts) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select a Contact"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index]["name"]!),
                  subtitle: Text("Phone: ${contacts[index]["phone"]}"),
                  onTap: () {
                    controller.addFriend(contacts[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

