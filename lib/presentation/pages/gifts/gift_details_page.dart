import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/utils/notification_service.dart';
import '../../../domain/entities/gift.dart';
import 'gift_controller.dart';


class GiftDetailsPage extends StatefulWidget {
  final GiftController giftController;
  final Gift gift;
  final bool isViewOnly; // New flag


  const GiftDetailsPage({
    super.key,
    required this.giftController,
    required this.gift,
    required this.isViewOnly,
  });

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController priceController;

  // Image management
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Status management
  late bool isAvailable;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing gift data
    nameController = TextEditingController(text: widget.gift.name);
    descriptionController = TextEditingController(text: widget.gift.description);
    categoryController = TextEditingController(text: widget.gift.category);
    priceController = TextEditingController(text: widget.gift.price.toString());

    // Determine availability status
    isAvailable = widget.gift.status != 'Pledged';
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    listenForGiftStatusUpdates(widget.gift.id);

  }

  void listenForGiftStatusUpdates(String giftId) {
    FirebaseDatabase.instance
        .ref('gifts/$giftId')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final status = data['status'];
        final giftName = data['name'];
        // Trigger notification if status changes to 'Pledged'
        if (status == 'Pledged' && currentUserId == widget.gift.userId) {
          // NotificationService().showGiftPledgedNotification(
          //   giftName: giftName,
          //   giftDescription: 'Someone pledged for "$giftName"!',
          //   bigPicture: null,
          // );
        }
        // Update the local state for UI
        setState(() {
          isAvailable = status != 'Pledged';
        });
      }
    });
  }

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: isAvailable ? _pickImage : null,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('lib/assets/gifts_defualt.webp') as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Gift Name"),
                enabled:!widget.isViewOnly && isAvailable,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                enabled:!widget.isViewOnly && isAvailable,

              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
                enabled:!widget.isViewOnly && isAvailable,

              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                enabled:!widget.isViewOnly && isAvailable,
              ),
              Row(
                children: [
                  const Text("Status:"),
                  // Only show toggle for friends, not the gift owner
                  if (widget.isViewOnly)
                    Switch(
                      value: !isAvailable, // True if "Pledged"
                      onChanged: (value) async {
                        if (value) {
                          await widget.giftController.pledgeGift(widget.gift.id);
                          // Trigger a notification when the gift is pledged
                          if (currentUserId == widget.gift.userId) {
                            await NotificationService().showGiftPledgedNotification(
                              giftName: widget.gift.name,
                              giftDescription: 'Someone pledged for "${widget.gift.name}"!',
                              bigPicture: null, // Add an image URL if available
                            );
                          }
                        } else {
                          await widget.giftController.unpledgeGift(widget.gift.id);
                        }
                        setState(() {
                          isAvailable = !value;
                        });
                      },
                    ),
                  if (!widget.isViewOnly)
                    Text(
                      isAvailable ? "Available" : "Pledged",
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (!widget.isViewOnly)
                ElevatedButton(
                  onPressed: widget.gift.status == "Pledged"
                      ? null
                      : () {
                    // Prepare updated gift with new details
                    final updatedGift = Gift(
                      id: widget.gift.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      status: isAvailable ? "Available" : "Pledged",
                      eventId: widget.gift.eventId,
                      userId: widget.gift.userId,
                    );
                    widget.giftController.updateGift(updatedGift);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.dispose();
  }
}