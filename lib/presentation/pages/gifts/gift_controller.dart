import 'package:flutter/material.dart';

class GiftController with ChangeNotifier {
  List<Map<String, dynamic>> gifts = [
    {
      "name": "Smartphone",
      "category": "Electronics",
      "status": "Available",
      "description": "A modern smartphone.",
      "price": 699,
    },
    {
      "name": "Book",
      "category": "Literature",
      "status": "Pledged",
      "description": "A classic novel.",
      "price": 15,
    },
  ];

  void addGift(Map<String, dynamic> gift) {
    gifts.add(gift);
    notifyListeners();
  }

  void updateGift(int index, Map<String, dynamic> updatedGift) {
    if (gifts[index]['status'] != 'Pledged') {
      gifts[index] = updatedGift;
      notifyListeners();
    }
  }

  void deleteGift(int index) {
    gifts.removeAt(index);
    notifyListeners();
  }
}
