import '../../data/local/models/event_model.dart';
/// Interface defining the contract for event-related operations.
abstract class EventRepository {
  /// Retrieves all events.
  Future<List<EventModel>> getAllEvents();

  /// Creates a new event.
  Future<void> createEvent(EventModel event);

  /// Updates an existing event.
  Future<void> updateEvent(EventModel event);

  /// Deletes an event by its ID.
  Future<void> deleteEvent(int eventId);

  Future<List<EventModel>> getEventsByStatus(String status);
}
