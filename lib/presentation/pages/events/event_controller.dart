import 'package:flutter/material.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_repository.dart';



class EventListController extends ChangeNotifier {
  final EventRepository repository;

  EventListController(this.repository);

  List<Event> events = [];
  bool isLoading = true;

  Future<void> loadEvents() async {
    isLoading = true;
    notifyListeners();

    try {
      events = await repository.getAllEvents();
    } catch (e) {
      // Handle error
      debugPrint("Failed to load events: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      // Option 1: Reload entire list after creation
      await repository.createEvent(event);
      await loadEvents(); // Reload the entire list to get the new event with ID
    } catch (e) {
      debugPrint("Failed to add event: $e");
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      // Ensure the ID is not null before proceeding
      if (id == null) {
        debugPrint("Cannot delete event with null ID");
        return;
      }

      // Delete the event from the repository
      await repository.deleteEvent(id);

      // Remove the event from the local list
      events.removeWhere((event) => event.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint("Failed to delete event: $e");
    }
  }

  void sortEvents(String criteria) {
    events.sort((a, b) {
      switch (criteria) {
        case "name":
          return a.name.compareTo(b.name);
        case "location":
          return a.location.compareTo(b.location);
        case "status":
          return a.status.compareTo(b.status);
        default:
          return 0;
      }
    });
    notifyListeners();
  }
}

