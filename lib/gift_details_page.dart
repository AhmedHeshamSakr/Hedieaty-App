// gift_details_page.dart
import 'package:flutter/material.dart';

class GiftDetailsPage extends StatelessWidget {
  const GiftDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gift Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Gift Name"),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                const Text("Status: Available"),
                Switch(
                  value: false,
                  onChanged: (bool value) {
                    // Handle pledge status toggle
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Upload image
              },
              child: const Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
