
// My Pledged Gifts Page
import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/pledged_gifts/pledge_controller.dart';
import 'package:provider/provider.dart';

class MyPledgedGiftsPage extends StatelessWidget {
  const MyPledgedGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pledgedGiftsController = Provider.of<PledgedGiftsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pledged Gifts"),
      ),
      body: ListView.builder(
        itemCount: pledgedGiftsController.pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGiftsController.pledgedGifts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              title: Text(gift["name"]),
              subtitle: Text("For: ${gift["friend"]} - Due: ${gift["dueDate"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showEditDialog(context, pledgedGiftsController, index, gift);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      pledgedGiftsController.deleteGift(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, pledgedGiftsController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(BuildContext context, PledgedGiftsController controller, int index, Map<String, dynamic> gift) {
    final nameController = TextEditingController(text: gift["name"]);
    final friendController = TextEditingController(text: gift["friend"]);
    final dueDateController = TextEditingController(text: gift["dueDate"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Pledged Gift"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Gift Name"),
              ),
              TextField(
                controller: friendController,
                decoration: const InputDecoration(labelText: "Friend's Name"),
              ),
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(labelText: "Due Date"),
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
                controller.editGift(index, {
                  "name": nameController.text,
                  "friend": friendController.text,
                  "dueDate": dueDateController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, PledgedGiftsController controller) {
    final nameController = TextEditingController();
    final friendController = TextEditingController();
    final dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Pledged Gift"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Gift Name"),
              ),
              TextField(
                controller: friendController,
                decoration: const InputDecoration(labelText: "Friend's Name"),
              ),
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(labelText: "Due Date"),
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
                controller.addGift({
                  "name": nameController.text,
                  "friend": friendController.text,
                  "dueDate": dueDateController.text,
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
}

