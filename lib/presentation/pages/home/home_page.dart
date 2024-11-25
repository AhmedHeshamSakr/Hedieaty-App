import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/home/home_controller.dart';
import 'package:hedieaty/core/constants/app_colors.dart';
import 'package:hedieaty/core/constants/app_styles.dart';
import 'package:hedieaty/presentation/widgets/friend_list_tile.dart';

class HomePage extends StatelessWidget {
  final HomeController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Welcome, ${controller.userName}",
              style: AppStyles.appBarTextStyle,
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: controller.logout,
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primary,
              ),
              onPressed: controller.createEvent,
              child: const Text("Create Your Own Event/List"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              focusNode: controller.searchFocusNode,
              decoration: InputDecoration(
                labelText: "Search Friends",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: controller.searchFriends,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Friend>>(
              future: controller.getFriends(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No friends found."));
                }

                final friends = snapshot.data!;
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return FriendListTile(
                      friend: friend,
                      onTap: () => controller.openFriendGifts(friend),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: controller.bottomNavigationItems,
        currentIndex: controller.selectedIndex,
        onTap: controller.onNavigationItemTapped,
      ),
    );
  }
}
