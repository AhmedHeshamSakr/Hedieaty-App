import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../domain/entities/gift.dart';
import 'gift_controller.dart';
import 'gift_details_page.dart';
import 'package:provider/provider.dart';



class GiftListPage extends StatefulWidget {
  final String eventId;
  final bool isViewOnly;


  const GiftListPage({
    super.key,
    required this.eventId, required this.isViewOnly,
  });

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GiftController>().loadGifts(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final giftController = context.watch<GiftController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isViewOnly ? "Friend's Gifts" : 'Event Gifts',
        ),
      ),
      body: Column(
        children: [
          // Only show Add and Sort buttons if not in view-only mode
          if (!widget.isViewOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showAddGiftDialog(context, widget.eventId),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Gift'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showSortMenu(context, giftController),
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Consumer<GiftController>(
              builder: (context, giftController, child) {
                debugPrint('Gift list rebuild. Gifts count: ${giftController.gifts.length}');
                return giftController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : giftController.gifts.isEmpty
                    ? const Center(child: Text('No gifts available for this event'))
                    : ListView.builder(
                  itemCount: giftController.gifts.length,
                  itemBuilder: (context, index) {
                    final gift = giftController.gifts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      color: gift.status == 'Available'
                          ? Colors.lightBlue[50]
                          : gift.status == 'Pledged'
                          ? Colors.lightGreen[50]
                          : Colors.white,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/gifts_defualt.webp'),
                        ),
                        title: Text(
                          gift.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Price: \$${gift.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gift.status,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: gift.status == 'Available'
                                    ? Colors.blue
                                    : gift.status == 'Pledged'
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!widget.isViewOnly)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.black45),
                                onPressed: () async {
                                  final confirmDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Gift'),
                                        content: const Text(
                                            'Are you sure you want to delete this gift?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete == true) {
                                    try {
                                      await giftController.deleteGift(gift.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${gift.name} deleted successfully')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to delete gift: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GiftDetailsPage(
                                giftController: giftController,
                                gift: gift,
                                isViewOnly: widget.isViewOnly, // Pass the flag here

                                // Pass isViewOnly to gift details
                                // isViewOnly: widget.isViewOnly,
                              ),
                            ),
                          );
                        },
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

  void _showAddGiftDialog(BuildContext context, String eventId) {
    final giftController = context.read<GiftController>();
    final formKey = GlobalKey<FormState>();
    final ImagePicker picker = ImagePicker();
    File? imageFile;

    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Gift'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          imageFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : null,
                      child: imageFile == null
                          ? Icon(Icons.add_a_photo, size: 50)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Gift Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a gift name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final newGift = Gift(
                      id: '', // Let the backend generate an ID
                      name: nameController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      status: 'Available',
                      eventId: eventId,
                      userId: '', // This will be set in the controller
                      gifterId: '', // This will be set later when pledged
                    );

                    // Use await to ensure the gift is added before closing the dialog
                    await giftController.addGift(newGift);

                    // Clear the controllers
                    nameController.clear();
                    descriptionController.clear();
                    categoryController.clear();
                    priceController.clear();

                    // Close the dialog
                    Navigator.pop(context);
                  } catch (e) {
                    // Show an error message if gift addition fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add gift: $e')),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSortMenu(BuildContext context, GiftController giftController) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Sort by Name'),
              onTap: () {
                giftController.sortGifts('name');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Sort by Price'),
              onTap: () {
                giftController.sortGifts('price');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Sort by Status'),
              onTap: () {
                giftController.sortGifts('status');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

