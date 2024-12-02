import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gift_controller.dart';

// Gift List Page

// Gift Details Page
class GiftDetailsPage extends StatelessWidget {
  final Map<String, dynamic>? gift;
  final int? index;

  const GiftDetailsPage({this.gift, this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final giftController = Provider.of<GiftController>(context);
    final TextEditingController nameController =
    TextEditingController(text: gift?["name"] ?? "");
    final TextEditingController descriptionController =
    TextEditingController(text: gift?["description"] ?? "");
    final TextEditingController categoryController =
    TextEditingController(text: gift?["category"] ?? "");
    final TextEditingController priceController =
    TextEditingController(text: gift?["price"]?.toString() ?? "");
    bool isAvailable = gift?["status"] != "Pledged";

    return Scaffold(
      appBar: AppBar(title: const Text("Gift Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Gift Name"),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                const Text("Status: Available"),
                Switch(
                  value: isAvailable,
                  onChanged: gift?["status"] == "Pledged"
                      ? null
                      : (value) {
                    isAvailable = value;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (index != null) {
                  giftController.updateGift(index!, {
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "category": categoryController.text,
                    "price": double.tryParse(priceController.text) ?? 0,
                    "status": isAvailable ? "Available" : "Pledged",
                  });
                } else {
                  giftController.addGift({
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "category": categoryController.text,
                    "price": double.tryParse(priceController.text) ?? 0,
                    "status": isAvailable ? "Available" : "Pledged",
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
