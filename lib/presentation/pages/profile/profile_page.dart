

import 'package:flutter/material.dart';
import 'package:hedieaty/presentation/pages/profile/profile_controller.dart';
import 'package:provider/provider.dart';
import '../pledged_gifts/pledged_gifts_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final nameController = TextEditingController(text: userController.userProfile["name"]);
    final emailController = TextEditingController(text: userController.userProfile["email"]);
    final phoneController = TextEditingController(text: userController.userProfile["phone"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace with user's profile image
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                enabled: isEditing,
                onChanged: (value) => userController.updateUserProfile("name", value),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                enabled: isEditing,
                onChanged: (value) => userController.updateUserProfile("email", value),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                enabled: isEditing,
                onChanged: (value) => userController.updateUserProfile("phone", value),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: userController.notificationsEnabled,
                    onChanged: userController.toggleNotifications,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MyPledgedGiftsPage(),
                    ),
                  );
                },
                child: const Text("View My Pledged Gifts"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

