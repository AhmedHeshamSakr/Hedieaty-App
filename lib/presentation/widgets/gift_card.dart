import 'package:flutter/material.dart';

class GiftCard extends StatelessWidget {
  final String giftName;
  final String giftStatus;

  const GiftCard({
    super.key,
    required this.giftName,
    required this.giftStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(giftName),
        subtitle: Text("Status: $giftStatus"),
      ),
    );
  }
}
