import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../events/event_list_page.dart';
import 'add_frinds_controller.dart';



class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final friendsController = Provider.of<FriendsController>(context, listen: false);
      await friendsController.loadFriends();
    });
  }


  @override
  Widget build(BuildContext context) {
    final friendsController = Provider.of<FriendsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Friends",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue, size: 28),
                  onPressed: () => _showAddFriendDialog(context, friendsController),
                ),
              ],
            ),
          ),
          Expanded(
            child: friendsController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: friendsController.friendsDetails.length,
              itemBuilder: (context, index) {
                final friend = friendsController.friendsDetails[index];
                return ListTile(
                  title: Text(friend.name ?? "No Name"),
                  subtitle: Text(friend.email ?? "No Email"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventListPage(isViewOnly: true , friendId: friend.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, FriendsController controller) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Friend"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Friend's Email"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text;
                if (email.isNotEmpty) {
                  try {
                    await controller.addFriendByEmail(email);
                    await controller.loadFriends();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add friend: ${e.toString()}'))
                    );
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
