import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gift_controller.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatelessWidget {
  const GiftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final giftController = Provider.of<GiftController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Add sorting logic here based on value
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "name", child: Text("Sort by Name")),
              PopupMenuItem(value: "category", child: Text("Sort by Category")),
              PopupMenuItem(value: "status", child: Text("Sort by Status")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: giftController.gifts.length,
        itemBuilder: (context, index) {
          final gift = giftController.gifts[index];
          final statusColor = gift["status"] == "Pledged" ? Colors.green : Colors.blue;
          return ListTile(
            title: Text(gift["name"]!),
            subtitle: Text("${gift["category"]} - ${gift["status"]}"),
            tileColor: statusColor.withOpacity(0.2),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == "edit") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiftDetailsPage(
                        gift: gift,
                        index: index,
                      ),
                    ),
                  );
                } else if (value == "delete") {
                  giftController.deleteGift(index);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: "edit", child: Text("Edit")),
                PopupMenuItem(value: "delete", child: Text("Delete")),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiftDetailsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Gifts"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: 0, // Hardcoded for now; update dynamically as needed
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }
}
