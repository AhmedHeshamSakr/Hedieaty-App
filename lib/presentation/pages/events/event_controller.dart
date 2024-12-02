import 'package:flutter/material.dart';

class EventListController extends ChangeNotifier {
  List<Map<String, String>> events = [
    {
      "name": "Birthday Party",
      "date": "2024-12-01",
      "category": "Personal",
      "status": "Upcoming"
    },
    {
      "name": "Wedding",
      "date": "2024-11-15",
      "category": "Family",
      "status": "Past"
    },
    {
      "name": "Graduation",
      "date": "2024-11-20",
      "category": "Celebration",
      "status": "Current"
    },
  ];

  void addEvent(Map<String, String> event) {
    events.add(event);
    notifyListeners();
  }

  void deleteEvent(int index) {
    events.removeAt(index);
    notifyListeners();
  }

  void sortEvents(String criteria) {
    events.sort((a, b) => a[criteria]!.compareTo(b[criteria]!));
    notifyListeners();
  }
}
