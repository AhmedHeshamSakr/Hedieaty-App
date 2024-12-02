import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_input_field.dart'; // Custom search input
import '../../widgets/friend_list_tile.dart'; // Friend list tile
import 'home_controller.dart'; // Your HomePageController

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageController(),
      child: Consumer<HomePageController>(
        builder: (context, controller, _) {
          final FocusNode searchFocusNode = FocusNode();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "Welcome, $userName",
                style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Logout",
                  onPressed: () => controller.logout(context),
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => controller.unfocusSearch(searchFocusNode),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality for creating an event/list
                      },
                      child: const Text("Create Your Own Event/List"),
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      hintText: "Search Friends",
                      focusNode: searchFocusNode,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3, // Example length
                        itemBuilder: (context, index) => FriendListTile(
                          friendName: 'Friend $index',
                          profilePic: Icons.person,
                          upcomingEvents: index, // Example data
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.selectedIndex,  // Reflects the updated selected index
              onTap: (index) => controller.onItemTapped(index, context),  // Update index and navigate
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              showUnselectedLabels: true,
              items: List.generate(controller.navItems.length, (index) {
                return BottomNavigationBarItem(
                  icon: Icon(controller.navItems[index]['icon']),
                  label: controller.navItems[index]['route'],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}