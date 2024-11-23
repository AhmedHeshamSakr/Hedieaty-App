// home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userName; // Pass the user's name as an argument

  const HomePage({super.key, required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> friends = [
    {"name": "Ahmed", "profilePic": Icons.person, "upcomingEvents": 1},
    {"name": "Mohamed", "profilePic": Icons.person, "upcomingEvents": 0},
    {"name": "Ali", "profilePic": Icons.person, "upcomingEvents": 2},
  ];
  late final String? userName; // Make nullable
  final FocusNode _searchFocusNode = FocusNode();
  late bool _isFirstLoad = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final routes = ['/eventList', '/profile', '/giftList', '/addFriend'];
    if (index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _logout() {
    // Handle logout logic, e.g., clear user session, navigate to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _searchFocusNode.unfocus();
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome, ${widget.userName ?? 'User'}", // Display the user's name
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: _logout,
            ),
          ],
        ),
        backgroundColor: Colors.blue, // Styling for the AppBar background color
        elevation: 5.0, // Add shadow to the AppBar
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)))
      ),
      body: GestureDetector(
        onTap: () => _searchFocusNode.unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: const Text("Create Your Own Event/List"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  labelText: "Search Friends",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(friend["profilePic"]),
                        ),
                        title: Text(friend["name"]),
                        subtitle: Text(friend["upcomingEvents"] > 0
                            ? "Upcoming Events: ${friend["upcomingEvents"]}"
                            : "No Upcoming Events"),
                        trailing: friend["upcomingEvents"] > 0
                            ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                                child: Text(
                                   friend["upcomingEvents"].toString(),
                                   style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                            : null,
                        onTap: () {
                          Navigator.pushNamed(context, '/friendGiftList', arguments: friend["name"]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.event),
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.card_giftcard),
            ),
            label: 'Gifts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.contact_phone),
            ),
            label: 'Add Friend',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}