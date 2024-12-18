import 'package:flutter/material.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/main_repository.dart';



class EventListController extends ChangeNotifier {
  final Repository repository;

  EventListController(this.repository) {
    loadEvents();
  }
  List<Event> events = [];
  bool isLoading = true;

  Future<void> resetEvents() async {
    if (isLoading) return;  // Prevent resetting if already loading
    await loadEvents();  // Reload the events (this will fetch your events)
    notifyListeners();
  }

  Future<void> loadEvents() async {
    isLoading = true;
    notifyListeners();

    try {
      events = await repository.getEvents();
    } catch (e) {
      debugPrint("Failed to load events: $e");
      events = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> loadFriendEvents(String friendId) async {
    isLoading = true;
    notifyListeners();
    try {
      // Assuming your repository has a method to fetch events for a specific user
      events = await repository.getEventsByUserId(friendId);
    } catch (e) {
      debugPrint('Error loading friend events: $e');
      events = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getFriendName(String friendId) async {
    try {
      final user = await repository.getUser(friendId);
      return user?.name ?? 'Unknown Friend';
    } catch (e) {
      debugPrint('Error fetching friend name: $e');
      return 'Unknown Friend';
    }
  }

  Future<void> addEvent(Event event) async {
    try {
       await repository.createEvent(event);
       await  loadEvents();
       // Sort events to maintain the current sorting order
      if (events.length > 1) {
        sortEvents(_lastSortCriteria, ascending: _lastSortAscending);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to add event: $e");
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      // Ensure the ID is not null before proceeding
      await repository.deleteEvent(id);

      // Remove the event from the local list
      events.removeWhere((event) => event.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint("Failed to delete event: $e");
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      // Update the event in the repository (both remote and local).
      await repository.updateEvent(event);
      // Find the index of the existing event in the local list.
      int index = events.indexWhere((existingEvent) =>
      existingEvent.id == event.id);
      if (index != -1) {
        // Replace the old event with the updated one.
        events[index] = event;
      } else {
        // If the event doesn't exist in the local list, add it (optional).
        events.add(event);
      }
      notifyListeners();
    } catch (e) {
      // Handle error.
      debugPrint("Failed to update event: $e");
    }
  }

  String _lastSortCriteria = 'date';
  bool _lastSortAscending = true;

  void sortEvents(String criteria, {bool ascending = true}) {
    _lastSortCriteria = criteria;
    _lastSortAscending = ascending;

    switch (criteria) {
      case 'name':
        events.sort((a, b) =>
        ascending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'date':
        events.sort((a, b) =>
        ascending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
        break;
      case 'status':
        const statusPriority = {'Current': 0, 'Upcoming': 1, 'Completed': 2};
        events.sort((a, b) {
          int priorityA = statusPriority[a.status] ?? 999;
          int priorityB = statusPriority[b.status] ?? 999;
          int comparison = priorityA.compareTo(priorityB);
          return ascending ? comparison : -comparison;
        });
        break;
    }
    notifyListeners();
  }
}