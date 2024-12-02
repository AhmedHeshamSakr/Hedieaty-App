import 'package:flutter/material.dart';

// Controller for Pledged Gifts
class PledgedGiftsController with ChangeNotifier {
  final List<Map<String, dynamic>> pledgedGifts = [
    {"name": "Headphones", "friend": "Ahmed", "dueDate": "2024-12-25"},
    {"name": "Watch", "friend": "Ali", "dueDate": "2024-11-01"},
  ];

  void editGift(int index, Map<String, dynamic> updatedGift) {
    pledgedGifts[index] = updatedGift;
    notifyListeners();
  }

  void addGift(Map<String, dynamic> newGift) {
    pledgedGifts.add(newGift);
    notifyListeners();
  }

  void deleteGift(int index) {
    pledgedGifts.removeAt(index);
    notifyListeners();
  }
}
